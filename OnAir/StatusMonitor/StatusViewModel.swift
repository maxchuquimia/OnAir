//
//  StatusViewModel.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation
import Combine
import NearPeer

final class StatusViewModel {

    struct UI {
        let userInfo: UserInfoUI
        let metaInfo: MetaInfoUI
        let menuBar: MenuBarUI
    }

    private let ui: UI
    private let network: LocalNetworkInterface
    private let computerStateMonitor: ComputerStateMonitorInterface
    private let usernameDataSource: UsernameDataSourceInterface
    private let messageDataSource: FriendlyMessageDataSourceInterface
    private let detectors: [Detector] = [BentoBoxReader(), OrangeDotLocator()]
    private var cancellables: Set<AnyCancellable> = []
    private var sendUserStateTimer: Timer?
    private var lastSentState: UserState?
    private var isSomeoneElseOnAir = false {
        didSet { updateIsOnAirMetaInfo() }
    }

    init(ui: UI, network: LocalNetworkInterface = LocalNetwork.shared, stateMontor: ComputerStateMonitorInterface = ComputerStateMonitor(), usernameDataSource: UsernameDataSourceInterface = UsernameDataSource(), messageDataSource: FriendlyMessageDataSourceInterface = FriendlyMessageDataSource()) {
        self.ui = ui
        self.network = network
        self.computerStateMonitor = stateMontor
        self.usernameDataSource = usernameDataSource
        self.messageDataSource = messageDataSource
        setup()
    }

}

private extension StatusViewModel {

    func setup() {
        network.state
            .sink { [weak self] in
                self?.userStatesDidChange(newStates: $0)
            }
            .store(in: &cancellables)

        network.status
            .sink { [weak self] in
                self?.handleNetworkStateChange(newValue: $0)
            }
            .store(in: &cancellables)

        network.connectedPeers
            .sink { [weak self] _ in
                self?.connectedPeersDidChange()
            }
            .store(in: &cancellables)

        computerStateMonitor.action = { [weak self] in
            self?.handleSystemAction(action: $0)
        }

        ui.userInfo.$currentUserTextFieldValue
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.handleUsernameChanged(newValue: newValue)
            }
            .store(in: &cancellables)

        network.start()

        sendCurrentUserState()
    }

    func handleSystemAction(action: ComputerStateMonitor.SystemAction) {
        switch action {
        case .didWake, .screensDidWake:
            network.start()
            sendCurrentUserState()
        case .willSleep, .screensDidSleep:
            network.stop()
        }
    }

    func handleUsernameChanged(newValue: String) {
        usernameDataSource.setUsername(to: newValue)
        sendCurrentUserState(force: true)
    }

    func handleNetworkStateChange(newValue: NearPeer.State) {
        switch newValue {
        case .idle: ui.metaInfo.statusMessage = L10n.Network.Status.idle
        case .searchingForActiveSessions: ui.metaInfo.statusMessage = L10n.Network.Status.searchingForActiveSessions
        case .broadcastingNewSession: ui.metaInfo.statusMessage = L10n.Network.Status.broadcastingNewSession
        case .hostingSession: ui.metaInfo.statusMessage = L10n.Network.Status.hostingSession
        case .connectedToExistingSession: ui.metaInfo.statusMessage = L10n.Network.Status.connectedToExistingSession
        }
    }

    func connectedPeersDidChange() {
        sendCurrentUserState(force: true)
    }

    func userStatesDidChange(newStates: [RemoteUserState]) {
        if newStates.isEmpty {
            ui.menuBar.statusImage = Asset.iconSearching
            isSomeoneElseOnAir = false
        } else {
            isSomeoneElseOnAir = newStates.contains { $0.isOnAir }
            ui.menuBar.statusImage = isSomeoneElseOnAir ? Asset.iconOnair : Asset.iconConnected
        }

        ui.userInfo.users = newStates.map {
            UserState(name: $0.name, isOnAir: $0.isOnAir)
        }

        changeMessage()
    }

    func sendCurrentUserState(force: Bool = false) {
        rescheduleSendUserStateTimer()
        let isQuietRequired = detectors.isQuietRequired
        let currentState = UserState(name: usernameDataSource.getUsername(), isOnAir: isQuietRequired)
        guard force || currentState != lastSentState else { return }
        lastSentState = currentState
        ui.userInfo.currentUser = currentState
        network.broadcast(state: currentState)
    }

    func rescheduleSendUserStateTimer() {
        sendUserStateTimer?.invalidate()
        sendUserStateTimer = .scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { [weak self] _ in
            self?.sendCurrentUserState()
        })
        sendUserStateTimer?.tolerance = 5.0
    }

    func changeMessage() {
        if isSomeoneElseOnAir {
            ui.metaInfo.friendlyMessage = messageDataSource.getQuietMessage()
        } else {
            ui.metaInfo.friendlyMessage = messageDataSource.getDefaultMessage()
        }
    }

    func updateIsOnAirMetaInfo() {
        ui.metaInfo.isSomeoneOnAir = isSomeoneElseOnAir
    }

}

