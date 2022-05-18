//
//  MainViewModel.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation
import AppKit
import Combine

final class OnAirViewModel {

    private var statusCheckTimer: Timer?
    private var previousQuietValue: Bool?
    private var networkState: [String: Packet] = [:]  {
        didSet { rebuildMenu() }
    }
    private let network: Net = .shared
    private let detectors: [Detector] = [BentoBoxReader(), OrangeDotLocator()]
    private var cancellables: Set<AnyCancellable> = []

    static var userId: String = {
        if UserDefaults.standard.string(forKey: "oaid") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "oaid")
        }
        return UserDefaults.standard.string(forKey: "oaid")!
    }()

    var stateDidUpdate: (String) -> Void = { _ in }
    var menuDidUpdate: (NSMenu) -> Void = { _ in }

    func setup() {
        network.connectedDevicesChanged = { [weak self] in self?.handleExternal(deviceList: $0) }
        network.didReceivePacket = { [weak self] in self?.handleExternal(packet: $0) }
        bind()

        rebuildMenu()
        startSharingStatusUpdates()
    }

}

private extension OnAirViewModel {

    func bind() {
        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.willSleepNotification, object: nil)
            .sink { [weak self] _ in
                self?.stopSharingStatusUpdates()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.screensDidSleepNotification, object: nil)
            .sink { [weak self] _ in
                self?.stopSharingStatusUpdates()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.screensDidWakeNotification, object: nil)
            .sink { [weak self] _ in
                self?.startSharingStatusUpdates()
            }
            .store(in: &cancellables)

        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.didWakeNotification, object: nil)
            .sink { [weak self] _ in
                self?.startSharingStatusUpdates()
            }
            .store(in: &cancellables)
    }

    func startSharingStatusUpdates() {
        network.begin(with: Self.userId)

        performStatusCheck(forceSending: true)

        statusCheckTimer?.invalidate()
        statusCheckTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [weak self] _ in
            self?.performStatusCheck()
        })
        statusCheckTimer?.tolerance = 5.0
    }

    func stopSharingStatusUpdates() {
        network.end()
        statusCheckTimer?.invalidate()
        statusCheckTimer = nil
    }

    func makeCurrentState() -> Packet {
        let isQuietRequired = detectors.isQuietRequired
        return Packet(
            name: ProcessInfo.processInfo.hostName,
            id: Self.userId,
            isQuietRequired: isQuietRequired
        )
    }

    func performStatusCheck(forceSending: Bool = false) {
        let packet = makeCurrentState()
        guard forceSending || packet.isQuietRequired != previousQuietValue else { return }
        defer { previousQuietValue = packet.isQuietRequired }
        network.broadcast(packet: packet)
        rebuildMenu(currentState: packet)
    }

    func handleExternal(packet: Packet) {
        networkState[packet.id] = packet
    }

    func handleExternal(deviceList: [String]) {
        // Broadcast our state again to new joiners
        performStatusCheck(forceSending: true)

        // Remove all items from networkState that are not in deviceList
        var newState: [String: Packet] = [:]
        for id in deviceList {
            newState[id] = newState[id]
        }
        networkState = newState
    }

    func rebuildMenu(currentState: Packet? = nil) {
        let isSomeoneNeedingQuiet = networkState.values.contains(where: { $0.isQuietRequired })
        let statusBarCopy = copy(isQuiet: isSomeoneNeedingQuiet, numberOfConnectedPeers: networkState.values.count)
        stateDidUpdate(statusBarCopy)

        var allUsers = Array(networkState.values)
        allUsers.append(currentState ?? makeCurrentState())
        allUsers = allUsers.sorted(by: { $0.name < $1.name })

        let menu = NSMenu()

        for user in allUsers {
            let title = copy(isQuiet: user.isQuietRequired, numberOfConnectedPeers: allUsers.count) + " " + user.name
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
            menu.addItem(item)
        }

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

        menuDidUpdate(menu)
    }

    func copy(isQuiet: Bool, numberOfConnectedPeers: Int) -> String {
        guard numberOfConnectedPeers > 0 else { return "🟨" }
        return isQuiet ? "🟥" : "🟩"
    }

}
