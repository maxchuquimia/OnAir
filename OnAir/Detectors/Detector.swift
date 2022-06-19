//
//  Detector.swift
//  OnAir
//
//  Created by Max Chuquimia on 19/5/2022.
//

import Foundation

protocol Detector {
    var isQuietRequired: Bool { get }
}

extension Array: Detector where Element == Detector {

    var isQuietRequired: Bool {
        for detector in self {
            if detector.isQuietRequired { return true }
        }
        return false
    }


}
