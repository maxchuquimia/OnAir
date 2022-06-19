//
//  UserState.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation

struct RemoteUserState: Hashable {
    
    let name: String
    let peerId: String
    let isOnAir: Bool
    let timestamp: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(peerId)
    }

    static func == (lhs: RemoteUserState, rhs: RemoteUserState) -> Bool {
        lhs.peerId == rhs.peerId
    }

}
