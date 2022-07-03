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
        let userInfo = UserInfoUI()
        let metaInfo = MetaInfoUI()
        let menuBar = MenuBarUI()

        let contentView = MenuBarPopoverView()
            .environmentObject(menuBar)
            .environmentObject(userInfo)
            .environmentObject(metaInfo)

        barController = SystemStatusBarController(contentView: contentView, ui: menuBar)
        viewModel = StatusViewModel(ui: .init(userInfo: userInfo, metaInfo: metaInfo, menuBar: menuBar))
    }

}

