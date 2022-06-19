//
//  SystemStatusBarController.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import AppKit
import SwiftUI
import Combine

final class SystemStatusBarController {

    private let statusBar = NSStatusBar.system
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private let eventMonitor: EventMonitor
    private let appUI = AppUI.shared.menuBar
    private var cancellables: Set<AnyCancellable> = []

    init<V: View>(contentView: V) {
        self.statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        self.popover = NSPopover()
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
        popover.contentViewController = NSHostingController(rootView: contentView)
        setup()
    }

}

private extension SystemStatusBarController {

    func setup() {
        guard let statusBarButton = statusItem.button else { preconditionFailure("Unable to use status bar item") }
        statusBarButton.action = #selector(togglePopover(sender:))
        statusBarButton.target = self
        eventMonitor.handler = { [weak self] _ in
            self?.hide()
        }
        appUI.$statusImage
            .sink { [weak self] icon in
                self?.statusItem.button?.image = icon.image
            }
            .store(in: &cancellables)
    }

    @objc func togglePopover(sender: AnyObject) {
        if popover.isShown {
            hide()
        } else {
            show()
        }
    }

    func show() {
        eventMonitor.start()
        guard let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
    }

    func hide() {
        popover.performClose(nil)
        eventMonitor.stop()
    }

}

private class EventMonitor {

    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    var handler: (NSEvent?) -> Void = { _ in }

    init(mask: NSEvent.EventTypeMask) {
        self.mask = mask
    }

    func start() {
        guard monitor == nil else { return }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
    }

    func stop() {
        guard let monitor = monitor else { return }
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }

    deinit {
        stop()
    }

}
