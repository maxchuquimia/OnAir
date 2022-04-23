//
//  NearPeerConstants.swift
//  OnAir
//
//  Created by Max Chuquimia on 1/5/2022.
//

import Foundation

public enum NearPeerConstants {

    static var connectionTimeout: TimeInterval = 10.0

    static func advertisingTimeout() -> TimeInterval {
        (connectionTimeout * 2) + TimeInterval(arc4random_uniform(UInt32(connectionTimeout)))
    }

    static func searchTimeout() -> TimeInterval {
        connectionTimeout * 2
    }

}
