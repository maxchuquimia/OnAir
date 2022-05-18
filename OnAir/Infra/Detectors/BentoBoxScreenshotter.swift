//
//  BentoBoxScreenshotter.swift
//  OnAir
//
//  Created by Max Chuquimia on 26/1/21.
//

import Cocoa

final class BentoBoxScreenshotter {

    private(set) var bentoBoxWindowID: CGWindowID?

    var isScreenCapturingPermitted: Bool {
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
            guard let name = item[kCGWindowOwnerName as String] as? String else { continue }
            guard name == "Control Centre" else { continue }
            guard let windowId = item[kCGWindowNumber as String] as? NSNumber else { continue }
            let title = item[kCGWindowName as String] as? String ?? ""
            guard title == "BentoBox" else { continue }
            return windowId.uint32Value
        }

        return nil
    }

    func capture(window: CGWindowID) -> NSBitmapImageRep? {
        guard let capturedImage = CGWindowListCreateImage(.null, [.optionIncludingWindow], window, [.shouldBeOpaque, .bestResolution, .boundsIgnoreFraming]) else { return nil }
        return NSBitmapImageRep(cgImage: capturedImage)
    }

}
