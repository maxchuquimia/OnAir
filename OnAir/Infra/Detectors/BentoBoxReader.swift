//
//  Detector.swift
//  OnAir
//
//  Created by Max Chuquimia on 25/4/2022.
//

import Foundation
import AppKit

final class BentoBoxReader: Detector {

    enum DotState {
        case unknown, missing, present
    }

    private let screenshotter = BentoBoxScreenshotter()

    var isQuietRequired: Bool {
        isOrangeDotPresent() == .present
    }

    var isScreenCapturingPermitted: Bool {
        screenshotter.isScreenCapturingPermitted
    }

    func isOrangeDotPresent() -> DotState {
        guard isScreenCapturingPermitted else { return .unknown }
        guard let bentoImage = screenshotter.getBentoBoxImage() else { return .unknown }
        print(bentoImage)
        let width = bentoImage.size.width
        let height = bentoImage.size.height
        let targetX = Int(width * 0.8)
        let targetY = Int(height * 0.5)
        guard targetX > 0 && targetY > 0 else { return .unknown }
        let color = bentoImage.colorAt(x: targetX, y: targetY)!.usingColorSpace(.genericRGB)!
        print(color.redComponent, color.greenComponent, color.blueComponent) // 0.9450980392156862 0.6823529411764706 0.37254901960784315

        if color.redComponent.isBetween(0.5, 0.99) && color.greenComponent.isBetween(0.2, 0.8) && color.blueComponent.isBetween(0.2, 0.5) {
            return .present
        } else {
            return .missing
        }
    }

}

private extension CGFloat {

    func isBetween(_ a: CGFloat, _ b: CGFloat) -> Bool {
        return self > a && self < b
    }

}
