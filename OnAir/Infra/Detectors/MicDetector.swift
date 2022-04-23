//
//  MicDetector.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation

final class MicDetector: Detector {

    private let monitor = AVMonitor()

    var isQuietModeRequired: Bool {
        monitor.audioClients.count > 0 || monitor.videoClients.count > 0
    }

    init() {
        monitor.start()
    }

}
