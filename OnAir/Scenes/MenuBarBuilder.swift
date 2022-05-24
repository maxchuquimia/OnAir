//
//  StatusBarItem.swift
//  OnAir
//
//  Created by Max Chuquimia on 29/5/2022.
//

import Cocoa
import Reduks

private var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

let menuStateSubscriber = { (state: AppState.Menu, dispatcher: ActionDispatcher) -> Void in
    let menu = NSMenu()

    for user in state.connectedUsers + [state.currentUser] {
        let title = "\(user.isOnAir) " + user.name
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menu.addItem(item)
    }

    menu.addItem(NSMenuItem.separator())

    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

    statusItem.menu = menu
    statusItem.button?.title = state.icon
}
