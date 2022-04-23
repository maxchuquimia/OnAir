//
//  MicDetector.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Foundation
import AVFoundation

final class MicDetector {

    let mon = AVMonitor()

    var current: Bool? = nil
//    var obs: [Any] = []
    func test() {
        mon.start()
//
//        let a = mon.observe(\.audioClients, options: [.initial, .new]) { [weak self] _, _ in
//            self?.update()
//        }
//
//        let b = mon.observe(\.videoClients, options: [.initial, .new]) { [weak self] _, _ in
//            self?.update()
//        }
//
//        obs = [a, b]

        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { _ in
            self.update()
        })
    }

    func update() {
//        print("==== Report ====")
//        print(mon.audioClients)
//        print(mon.videoClients)
        let isOnAir = mon.audioClients.count > 0 || mon.videoClients.count > 0
        if current != isOnAir {
            Net.shared.set(isOnAir: isOnAir)
        }
        current = isOnAir
    }

    func t() {

//        let sesh = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone, .externalUnknown], mediaType: .audio, position: .unspecified)
//        for device in sesh.devices {
//            let isRunning = device.isInUseByAnotherApplication
//            print("Mic \(device.manufacturer), \(device.modelID) isRunning=\(isRunning)")
//            var a: UInt32 = 0
//            var b: Bool = false
//            let s = NSSelectorFromString("connectionID")
////            device.responds(to: s)
//
////            CoreAudio.AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceIsRunningSomewhere, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
////            let id: AudioDeviceID! = device.perform(s)
////            CoreAudio.AudioDeviceGetProperty(id, 0 , false, kAudioDevicePropertyDeviceIsRunningSomewhere, &a, &b)
//        }
    }


}
