//
//  AppDelegate.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Cocoa
import Firebase

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    let mon = MicDetector()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
        print(Net.shared)
        mon.test()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "🟢"
//                        button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        setupMenus()

        Net.shared.isSomeoneOnAir = { [unowned self] isOn in
            if isOn {
                didTapTwo()
            } else {
                didTapThree()
            }
        }
    }
    
    func setupMenus() {
        // 1
        let menu = NSMenu()
        
        // 2
        let one = NSMenuItem(title: "Focus mode", action: #selector(didTapOne) , keyEquivalent: "1")
        menu.addItem(one)
        
        let two = NSMenuItem(title: "Meeting", action: #selector(didTapTwo) , keyEquivalent: "2")
        menu.addItem(two)
        
        let three = NSMenuItem(title: "Available", action: #selector(didTapThree) , keyEquivalent: "3")
        menu.addItem(three)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // 3
        statusItem.menu = menu
    }
    // 1
    private func changeStatusBarButton(_ icon: String) {
        if let button = statusItem.button {
            button.title = icon
            //            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }
    @objc func didTapOne() {
        changeStatusBarButton("💻")
    }
    
    @objc func didTapTwo() {
        changeStatusBarButton("🛑")
    }
    
    @objc func didTapThree() {
        changeStatusBarButton("🟢")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
}


