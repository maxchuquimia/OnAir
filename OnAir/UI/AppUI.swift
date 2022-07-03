//
//  AppUI.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import Foundation
import SwiftUI

/// Describes the UI of the entire app.

final class MenuBarUI: ObservableObject {
    @Published var statusImage: ImageAsset = Asset.iconSearching
}

final class UserInfoUI: ObservableObject {
    @Published var users: [UserState] = []
    @Published var currentUser: UserState = UserState(name: "", isOnAir: false)
    @Published var currentUserTextFieldValue: String = ""
}

final class MetaInfoUI: ObservableObject {
    @Published var statusMessage: String = ""
    @Published var friendlyMessage: String = ""
    @Published var isSomeoneOnAir: Bool = false
    @Published var hasScreenRecordingPermission: Bool = ScreenRecordingInfo.isScreenCapturingPermitted
}
