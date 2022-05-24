//
//  NotificationCenter.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Foundation
import Combine
import Reduks
import AppKit

enum NotificationAction: Action {
    case willSleep, screensDidSleep, screensDidWake, didWake
}

private var cancellables: Set<AnyCancellable> = []

func boostrapNotificationCenter() {
    map(notification: NSWorkspace.willSleepNotification, in: NSWorkspace.shared.notificationCenter, to: .willSleep)
    map(notification: NSWorkspace.screensDidSleepNotification, in: NSWorkspace.shared.notificationCenter, to: .screensDidSleep)
    map(notification: NSWorkspace.screensDidWakeNotification, in: NSWorkspace.shared.notificationCenter, to: .screensDidWake)
    map(notification: NSWorkspace.didWakeNotification, in: NSWorkspace.shared.notificationCenter, to: .didWake)
}

private func map(notification: NSNotification.Name, in center: NotificationCenter, to action: NotificationAction) {
    center
        .publisher(for: notification, object: nil)
        .sink { _ in
            store.dispatch(action)
        }
        .store(in: &cancellables)
}
