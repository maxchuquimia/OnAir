//
//  AppDelegate.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    private let viewModel = OnAirViewModel()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
        button.title = "👋"
//                        button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }

        viewModel.menuDidUpdate = { [weak self] menu in
            self?.statusItem.menu = menu
        }

        viewModel.stateDidUpdate = { [weak self] value in
            guard let button = self?.statusItem.button else { return }
            button.title = value
        }

        viewModel.setup()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
}


