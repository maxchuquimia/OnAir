//
//  AppUI.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation
import SwiftUI

/// Describes the UI of the entire app.
/// Used for dirtily binding SwiftUI to a traditional ViewModel class.
final class AppUI {

    static let shared = AppUI()

    final class MenuBar: ObservableObject {
        @Published var statusImage: ImageAsset = Asset.iconSearching
    }

    final class UserInfo: ObservableObject {
        @Published var users: [UserState] = []
        @Published var currentUser: UserState = UserState(name: "", isOnAir: false)
        @Published var currentUserTextFieldValue: String = ""
    }

    final class MetaInfo: ObservableObject {
        @Published var statusMessage: String = ""
        @Published var friendlyMessage: String = ""
        @Published var isSomeoneOnAir: Bool = false
        @Published var hasScreenRecordingPermission: Bool = ScreenRecordingInfo.isScreenCapturingPermitted
    }

    let menuBar = MenuBar()
    let userInfo = UserInfo()
    let metaInfo = MetaInfo()

}
