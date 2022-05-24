//
//  AppDelegate.swift
//  OnAir
//
//  Created by Max Chuquimia on 23/4/2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupRedux()
        store.dispatch(NetworkAction.begin)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {

    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
}


