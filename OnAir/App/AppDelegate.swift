//
//  AppDelegate.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private var barController: SystemStatusBarController!
    private var viewModel: StatusViewModel!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = MenuBarPopoverView()
            .environmentObject(AppUI.shared.menuBar)
            .environmentObject(AppUI.shared.userInfo)
            .environmentObject(AppUI.shared.metaInfo)

        // Stop SwiftUI previews from crashing
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return }

        barController = SystemStatusBarController(contentView: contentView)
        viewModel = StatusViewModel()
    }

}

