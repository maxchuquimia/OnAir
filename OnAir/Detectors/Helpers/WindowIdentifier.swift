//
//  WindowIdentifier.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation

final class WindowInfoRecognizer {

    enum Window {
        case bentoBox
        case statusIndicator
        case sensorIndicators
    }

    let types: Set<Window>

    init(types: Set<Window>) {
        self.types = types
    }

}

extension WindowInfoRecognizer {

    func isWindowInfoRecognised(window: [String: Any]) -> Bool {
        guard let name = window[kCGWindowOwnerName as String] as? String else { return false }
        guard let title = window[kCGWindowName as String] as? String else { return false }
        return types.contains(where: { $0.matches(name: name, title: title) })
    }

}

private extension WindowInfoRecognizer.Window {

    func matches(name: String, title: String) -> Bool {
        windowNames.contains(name) && windowTitles.contains(title)
    }

    private var windowNames: Set<String> {
        switch self {
        case .bentoBox, .sensorIndicators:
            return ["Control Centre", "Control Center"]
        case .statusIndicator:
            return ["Window Server"]
        }
    }

    private var windowTitles: Set<String> {
        switch self {
        case .bentoBox:
            return ["BentoBox"]
        case .statusIndicator:
            return ["StatusIndicator"]
        case .sensorIndicators:
            return ["SensorIndicators"]
        }
    }

}
