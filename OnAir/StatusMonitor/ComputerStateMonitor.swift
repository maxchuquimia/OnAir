//
//  SystemStateMonitor.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import AppKit
import Combine

protocol ComputerStateMonitorInterface: AnyObject {
    var action: (ComputerStateMonitor.SystemAction) -> Void { get set }
}

final class ComputerStateMonitor: ComputerStateMonitorInterface {

    enum SystemAction {
        case willSleep, screensDidSleep, screensDidWake, didWake
    }

    var action: (SystemAction) -> Void = { _ in }
    private var cancellables: Set<AnyCancellable> = []

    init() {
        map(notification: NSWorkspace.willSleepNotification, in: NSWorkspace.shared.notificationCenter, to: .willSleep)
        map(notification: NSWorkspace.screensDidSleepNotification, in: NSWorkspace.shared.notificationCenter, to: .screensDidSleep)
        map(notification: NSWorkspace.screensDidWakeNotification, in: NSWorkspace.shared.notificationCenter, to: .screensDidWake)
        map(notification: NSWorkspace.didWakeNotification, in: NSWorkspace.shared.notificationCenter, to: .didWake)
    }

    private func map(notification: NSNotification.Name, in center: NotificationCenter, to action: SystemAction) {
        center
            .publisher(for: notification, object: nil)
            .sink { [weak self] _ in
                self?.action(action)
            }
            .store(in: &cancellables)
    }

}
