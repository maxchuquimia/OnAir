//
//  BentoBoxScreenshotter.swift
//  OnAir
//
//  Created by Max Chuquimia on 26/1/21.
//

import Cocoa

final class BentoBoxScreenshotter {

    private(set) var bentoBoxWindowID: CGWindowID?
    private let windowIdentifier = WindowInfoRecognizer(types: [.bentoBox])

    var isScreenCapturingPermitted: Bool {
        ScreenRecordingInfo.isScreenCapturingPermitted
    }

    func getBentoBoxImage() -> NSBitmapImageRep? {
        if bentoBoxWindowID == nil {
            bentoBoxWindowID = getBentoBoxWindowID()
        }

        guard let _bentoBoxWindowID = bentoBoxWindowID else { return nil }
        let image = capture(window: _bentoBoxWindowID)

        if let image = image {
            return image
        } else {
            // Maybe bentoBoxWindowID has changed somehow?
            guard let newBentoBoxWindowID = getBentoBoxWindowID() else { return nil }
            bentoBoxWindowID = newBentoBoxWindowID
            return capture(window: newBentoBoxWindowID)
        }
    }

}

private extension BentoBoxScreenshotter {

    func getBentoBoxWindowID() -> CGWindowID? {
        guard let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] else { return nil }

        for item in list {
            guard windowIdentifier.isWindowInfoRecognised(window: item) else { continue }
            guard let windowId = item[kCGWindowNumber as String] as? NSNumber else { continue }
            return windowId.uint32Value
        }

        return nil
    }

    func capture(window: CGWindowID) -> NSBitmapImageRep? {
        guard let capturedImage = CGWindowListCreateImage(.null, [.optionIncludingWindow], window, [.shouldBeOpaque, .bestResolution, .boundsIgnoreFraming]) else { return nil }
        return NSBitmapImageRep(cgImage: capturedImage)
    }

}
