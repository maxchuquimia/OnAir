//
//  OrangeDotLocator.swift
//  OnAir
//
//  Created by Max Chuquimia on 19/5/2022.
//

import Foundation

final class OrangeDotLocator: Detector {

    var isQuietRequired: Bool {
        doesOrangeDotExist()
    }

    func doesOrangeDotExist() -> Bool {
        guard let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] else { return false }

        for item in list {
            guard let name = item[kCGWindowOwnerName as String] as? String else { continue }
            guard name == "Window Server" else { continue }
//            guard let windowId = item[kCGWindowNumber as String] as? NSNumber else { continue }
            let title = item[kCGWindowName as String] as? String ?? ""
            guard title == "StatusIndicator" else { continue }
            return true
        }

        return false
    }

}
