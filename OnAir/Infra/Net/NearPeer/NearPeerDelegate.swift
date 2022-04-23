//
//  NearPeerDelegate.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation

public protocol NearPeerDelegate: AnyObject {
    func handle(error: Error)
    func connectedPeersDidChange(to peers: Set<NearPeer.ID>)
    func didReceiveMessageFromPeer(message: Data, peer: NearPeer.ID)
}
