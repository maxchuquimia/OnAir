//
//  UsernameDataSource.swift
//  OnAir
//
//  Created by Max Chuquimia on 14/6/2022.
//

import Foundation

protocol UsernameDataSourceInterface {
    func getUsername() -> String
    func setUsername(to newValue: String)
}

final class UsernameDataSource {

    private let usernameDefaultsKey = "UsernameOverride"

    private var defaultName: String {
        ProcessInfo.processInfo.hostName
    }

}

extension UsernameDataSource: UsernameDataSourceInterface {

    func getUsername() -> String {
        UserDefaults.standard.string(forKey: usernameDefaultsKey) ?? defaultName
    }

    func setUsername(to newValue: String) {
        let value = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard value != defaultName else { return }
        if value.isEmpty {
            UserDefaults.standard.removeObject(forKey: usernameDefaultsKey)
        } else {
            UserDefaults.standard.set(value, forKey: usernameDefaultsKey)
        }
    }

}
