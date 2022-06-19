//
//  QuietStatusView.swift
//  OnAir
//
//  Created by Max Chuquimia on 12/6/2022.
//

import SwiftUI
import LaunchAtLogin

struct MenuBarPopoverView: View {

    @EnvironmentObject var userInfo: AppUI.UserInfo
    @EnvironmentObject var metaInfo: AppUI.MetaInfo
    @ObservedObject private var launchAtLogin = LaunchAtLogin.observable

    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
                .scaleEffect(1.5)

            VStack {
                VStack(spacing: 2) {
                    if !userInfo.users.isEmpty {
                        FriendlyMessageView()
                        Spacer()
                    } else {
                        Spacer()
                            .frame(height: 8)
                    }
                    ListTitleView(title: L10n.Popover.Users.Remote.title)
                    if userInfo.users.isEmpty {
                        DisconnectedView(text: metaInfo.statusMessage)
                    } else {
                        ForEach(userInfo.users, id: \.self) { user in
                            UserStatusView(state: user, isEditable: false, onUsernameChanged: nil)
                        }
                    }
                    Spacer()
                        .frame(height: 6)
                    if metaInfo.hasScreenRecordingPermission {
                        ListTitleView(title: L10n.Popover.Users.Me.title)
                        UserStatusView(state: userInfo.currentUser, isEditable: true, onUsernameChanged: { userInfo.currentUserTextFieldValue = $0 })
                        Spacer()
                    }
                }

                if !metaInfo.hasScreenRecordingPermission {
                    ScreenPermissionView()
                }

                Spacer()
                VersionView()
                    .layoutPriority(1)
                HStack {
                    Toggle(LocalizedStringKey(L10n.Popover.Settings.launchAtLogin), isOn: $launchAtLogin.isEnabled)
                    Spacer()
                    Button(L10n.Popover.Settings.quit) {
                        NSApplication.shared.terminate(nil)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
    }

}

struct MenuBarPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarPopoverView()
            .frame(width: 300)
            .environmentObject(AppUI.shared.menuBar)
            .environmentObject(AppUI.shared.userInfo)
            .environmentObject(AppUI.shared.metaInfo)
    }
}
