//
//  NearPeerID.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation
import MultipeerConnectivity

public extension NearPeer {

    struct ID: Hashable {
        let id: String

        init() {
            let _id = UUID()
                .uuidString
                .replacingOccurrences(of: "-", with: "")
            id = String(_id[_id.startIndex..<_id.index(_id.startIndex, offsetBy: 15)])
        }

        init(id: String) {
            self.id = id
        }

        init(peerID: MCPeerID) {
            self.id = peerID.displayName
        }
    }

}
