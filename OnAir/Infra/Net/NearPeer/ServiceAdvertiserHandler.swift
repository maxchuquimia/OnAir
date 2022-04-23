//
//  ServiceAdvertiserHandler.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation
import MultipeerConnectivity

final class ServiceAdvertiserHandler: NSObject, MCNearbyServiceAdvertiserDelegate {

    var errorHandler: (Error) -> Void = { _ in }
    var willAcceptPeerInvitationHandler = { }

    private let session: MCSession

    init(session: MCSession) {
        self.session = session
        super.init()
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        willAcceptPeerInvitationHandler()
        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        OperationQueue.main.addOperation { [weak self] in
            self?.errorHandler(error)
        }
    }

}
