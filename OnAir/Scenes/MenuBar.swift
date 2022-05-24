//
//  MenuBar.reducer.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation
import Reduks

let menuBarReducer = { (action: PeerAction, state: inout AppState.Menu) in
    switch action {
    case let .message(packet):
        if let idx = state.connectedUsers.firstIndex(where: { $0.id == packet.id }) {
            state.connectedUsers[idx].isOnAir = packet.isOnAir
            state.connectedUsers[idx].name = packet.name
        } else {
            // Add the new user
            state.connectedUsers.append(
                AppState.Menu.User(id: packet.id, name: packet.name, isOnAir: packet.isOnAir)
            )
        }
    case let .peerListChanged(peers):
        // Remove stale users
        state.connectedUsers = state.connectedUsers.filter { user in
            peers.contains { $0 == user.id }
        }
    }

}
