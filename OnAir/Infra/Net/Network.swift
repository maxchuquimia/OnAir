//
//  Net.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation
import NearPeer
import Reduks

enum NetworkAction: Action {
    case begin
    case end
    case broadcast(data: Data)
}

// PeerAction
enum IncomingNetworkAction: Action {
    case handleMessage(Data, from: NearPeer.ID)
    case handlePeerListChange(Set<NearPeer.ID>)
    case handleError(Error)
}

private var nearPeer: NearPeer?
private var delegate = NearPeerDelegateImp()

let networkActionReducer = { (action: NetworkAction, state: inout AppState.Network) in
    switch action {
    case .begin:
        nearPeer?.stop()
        nearPeer = NearPeer(serviceType: "cponair")
        nearPeer?.delegate = delegate
        state.isRunning = true
    case .end:
        nearPeer?.stop()
        nearPeer = nil
        state.isRunning = false
    case let .broadcast(data):
        nearPeer?.broadcast(data: data)
    }
}

//let incomingNetworkActionReducer = { (action: IncomingNetworkAction, state: inout AppState.Network) in
//    switch action {
//    case let .handlePeerListChange(peerListChange: peers):
//        state.peers = peers
//    default: break // store peer states
//    }
//}

private final class NearPeerDelegateImp: NearPeerDelegate {

    func handle(error: Error) {
        print("Error! \(error)")
        store.dispatch(IncomingNetworkAction.handleError(error))
    }

    func connectedPeersDidChange(to peers: Set<NearPeer.ID>) {
        print("Connected peers: \(peers)")
        store.dispatch(IncomingNetworkAction.handlePeerListChange(peers))
        store.dispatch(RefreshStateAction())
    }

    func didReceiveMessageFromPeer(message: Data, peer: NearPeer.ID) {
        store.dispatch(IncomingNetworkAction.handleMessage(message, from: peer))
    }

}
