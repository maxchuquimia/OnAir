//
//  MenuState.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation

extension AppState {

    struct Menu: Equatable {

        struct User: Equatable {
            var id: String
            var name: String
            var isOnAir: Bool
        }

        var icon = "🟨"
        var connectedUsers: [User] = []
        var currentUser: User = User(id: "0", name: ProcessInfo.processInfo.hostName, isOnAir: false)

    }

}
