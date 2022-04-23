//
//  NearPeer.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation
import MultipeerConnectivity

public final class NearPeer: NSObject {

    public enum State: Equatable {
        case idle
        case searchingForActiveSessions
        case broadcastingNewSession
        case hostingSession
        case connectedToExistingSession
    }

    public weak var delegate: NearPeerDelegate?
    public let localID: ID
    public private(set) var state: State = .idle {
        didSet { stateDidChange(from: oldValue) }
    }

    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession

    private let advertiserHandler: ServiceAdvertiserHandler
    private let browserHandler: ServiceBrowserHandler
    private let sessionHandler: SessionHandler

    private var nextOperationTimer: Timer?

    // Recommend passing a 15 char UUID as displayName
    required init(serviceType: String, id: NearPeer.ID = NearPeer.ID()) {
        self.localID = id
        let peer = MCPeerID(displayName: id.id)
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)

        advertiserHandler = ServiceAdvertiserHandler(session: session)
        browserHandler = ServiceBrowserHandler(session: session)
        sessionHandler = SessionHandler()

        super.init()
        setup()
    }

    deinit {
        stop()
    }

}

public extension NearPeer {

    func joinPeers() {
        guard state == .idle else { return }
        searchForActiveSessions()
    }

    func stop() {
        nextOperationTimer?.invalidate()
        session.disconnect()
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        state = .idle
    }

}

private extension NearPeer {

    func setup() {
        advertiser.delegate = advertiserHandler
        browser.delegate = browserHandler
        session.delegate = sessionHandler

        advertiserHandler.errorHandler = { [weak self] in self?.handle(error: $0) }
        browserHandler.errorHandler = { [weak self] in self?.handle(error: $0) }
        sessionHandler.peerUpdateHandler = { [weak self] in self?.handlePeerListChange(connectedPeers: $0) }
        sessionHandler.receivedDataHandler = { [weak self] in self?.handle(data: $0, from: $1) }
    }

    func searchForActiveSessions() {
        advertiser.stopAdvertisingPeer()
        state = .searchingForActiveSessions

        browserHandler.willInvitePeerToSessionHandler = { [weak self] in
            self?.nextOperationTimer?.invalidate()
            self?.state = .connectedToExistingSession
        }

        browser.startBrowsingForPeers()

        nextOperationTimer?.invalidate()
        nextOperationTimer = .scheduledTimer(withTimeInterval: NearPeerConstants.searchTimeout(), repeats: false, block: { [weak self] _ in
            // Failed to find an existing session in time, so create a new session
            self?.broadcastNewSession()
        })
        nextOperationTimer?.tolerance = 1.0
    }

    func broadcastNewSession() {
        browser.stopBrowsingForPeers()
        state = .broadcastingNewSession

        advertiserHandler.willAcceptPeerInvitationHandler = { [weak self] in
            self?.nextOperationTimer?.invalidate()
            self?.state = .hostingSession
        }

        advertiser.startAdvertisingPeer()

        nextOperationTimer?.invalidate()
        nextOperationTimer = .scheduledTimer(withTimeInterval: NearPeerConstants.advertisingTimeout(), repeats: false, block: { [weak self] _ in
            // Failed to find an existing session in time, so create a new session
            self?.searchForActiveSessions()
        })
        nextOperationTimer?.tolerance = 1.0
    }

    func stateDidChange(from oldValue: State) {
        print("State changed: \(oldValue) -> \(state)")
    }

    func handle(error: Error) {
        switch error {
        case MCError.timedOut, MCError.notConnected:
            switch state {
            case .searchingForActiveSessions, .connectedToExistingSession:
                broadcastNewSession()
            case .broadcastingNewSession, .hostingSession:
                searchForActiveSessions()
            case .idle:
                stop()
                joinPeers()
            }

        default:
            delegate?.handle(error: error)
        }
    }

    func handlePeerListChange(connectedPeers: [MCPeerID]) {
        delegate?.connectedPeersDidChange(
            to: Set(connectedPeers.map(ID.init))
        )
    }

    func handle(data: Data, from peer: MCPeerID) {
        delegate?.didReceiveMessageFromPeer(message: data, peer: .init(peerID: peer))
    }

}
