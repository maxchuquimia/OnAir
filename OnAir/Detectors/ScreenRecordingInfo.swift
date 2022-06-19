//
//  ScreenRecordingInfo.swift
//  OnAir
//
//  Created by Max Chuquimia on 18/6/2022.
//

import AppKit

struct ScreenRecordingInfo {

    static var isScreenCapturingPermitted: Bool {
//        return false;
        let stream = CGDisplayStream(
            dispatchQueueDisplay: CGMainDisplayID(),
            outputWidth: 1,
            outputHeight: 1,
            pixelFormat: Int32(kCVPixelFormatType_32BGRA),
            properties: nil,
            queue: DispatchQueue.global(),
            handler: { _, _, _, _ in }
        )

        return stream != nil
    }

}
