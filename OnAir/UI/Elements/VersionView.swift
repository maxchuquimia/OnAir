//
//  VersionView.swift
//  OnAir
//
//  Created by Max Chuquimia on 19/6/2022.
//

import SwiftUI

struct VersionView: View {

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(L10n.Popover.Version.message(Bundle.main.releaseVersionNumber, Bundle.main.buildVersionNumber))
                Text(L10n.Popover.Version.Updates.title)
                    .overlay { // .underline() doesn't render for some reason
                        Color(nsColor: .textColor)
                            .opacity(0.7)
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: L10n.Popover.Version.Updates.url)!)
                    }
                Spacer()
                Text(L10n.Popover.Version.Support.title)
                    .overlay {
                        Color(nsColor: .textColor)
                            .opacity(0.7)
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    .onTapGesture {
                        NSWorkspace.shared.open(URL(string: L10n.Popover.Version.Support.url)!)
                    }
            }
            .font(.footnote)

        }
    }

}

private extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}


struct VersionView_Previews: PreviewProvider {
    static var previews: some View {
        VersionView()
    }
}
