//
//  Packet.swift
//  OnAir
//
//  Created by Max Chuquimia on 25/4/2022.
//

import Foundation

struct Packet: Hashable {

    private static let delimiter = ";;"

    let name: String
    let id: String
    let isOnAir: Bool

    var stringValue: String {
        [name, id, String(isOnAir)].joined(separator: Packet.delimiter)
    }

    init(name: String, id: String, isOnAir: Bool) {
        self.name = name
        self.id = id
        self.isOnAir = isOnAir
    }

    init?(string: String) {
        let components = string.components(separatedBy: Packet.delimiter)
        guard components.count >= 3 else { return nil }
        self.name = components[0]
        self.id = components[1]
        self.isOnAir = components[2] == String(true)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Packet, rhs: Packet) -> Bool {
        lhs.id == rhs.id
    }

}
