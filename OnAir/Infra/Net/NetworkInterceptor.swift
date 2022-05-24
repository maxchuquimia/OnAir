//
//  NetworkInterceptor.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation
import Reduks
import NearPeer

enum PeerAction: Action {
    case message(Packet)
    case peerListChanged(Set<String>)
}

let incomingNetworkActionInterceptor = { (action: IncomingNetworkAction, state: AppState) -> InterceptorResult in
    switch action {
    case let .handleMessage(message, _):
        if let packet = Packet(string: String(data: message, encoding: .utf8) ?? "") {
            return .map(PeerAction.message(packet))
        } else { // Handle more types here
            return .block
        }
    case let .handlePeerListChange(peers):
        return .map(PeerAction.peerListChanged(Set(peers.map(\.id))))
    case .handleError:
        return .block
    }
}

let networkActionInterceptor = { (action: NetworkAction, state: AppState.Network) -> InterceptorResult in
    switch action {
    case .begin: return state.isRunning ? .block : .continue
    case .end: return state.isRunning ? .continue : .block
    case .broadcast: return state.isRunning ? .continue : .block
    }
}
