//
//  ServiceBrowserHandler.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation
import MultipeerConnectivity

final class ServiceBrowserHandler: NSObject, MCNearbyServiceBrowserDelegate {

    var errorHandler: (Error) -> Void = { _ in }
    var willInvitePeerToSessionHandler = { }

    private let session: MCSession

    init(session: MCSession) {
        self.session = session
        super.init()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        willInvitePeerToSessionHandler()
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: NearPeerConstants.connectionTimeout)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Unused
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        OperationQueue.main.addOperation { [weak self] in
            self?.errorHandler(error)
        }
    }

}
