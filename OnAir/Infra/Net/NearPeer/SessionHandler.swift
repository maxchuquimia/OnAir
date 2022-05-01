//
//  SessionHandler.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation
import MultipeerConnectivity

final class SessionHandler: NSObject, MCSessionDelegate {

    var peerUpdateHandler: ([MCPeerID]) -> Void = { _ in }
    var receivedDataHandler: (Data, MCPeerID) -> Void = { _, _ in }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function, peerID, state)
        let connectedPeers = session.connectedPeers
        OperationQueue.main.addOperation { [weak self] in
            self?.peerUpdateHandler(connectedPeers)
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        OperationQueue.main.addOperation { [weak self] in
            self?.receivedDataHandler(data, peerID)
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Unused
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Unused
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Unused
    }

    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

}
