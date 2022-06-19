//
//  OrangeDotLocator.swift
//  OnAir
//
//  Created by Max Chuquimia on 19/5/2022.
//

import Foundation

final class OrangeDotLocator: Detector {

    private let windowIdentifier = WindowInfoRecognizer(types: [.statusIndicator, .sensorIndicators])

    var isQuietRequired: Bool {
        doesOrangeDotExist()
    }

    func doesOrangeDotExist() -> Bool {
        guard let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] else { return false }
        return list.contains {
            windowIdentifier.isWindowInfoRecognised(window: $0)
        }
    }

}
