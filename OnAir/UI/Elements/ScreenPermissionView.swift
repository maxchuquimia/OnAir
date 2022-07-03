//
//  CriticalErrorView.swift
//  OnAir
//
//  Created by Max Chuquimia on 18/6/2022.
//

import SwiftUI

struct ScreenPermissionView: View {

    var body: some View {
        VStack(spacing: 6) {
            Spacer()

            Text(LocalizedStringKey(L10n.Popover.ScreenRec.title))
                .font(.body)
                .bold()
                .multilineTextAlignment(.center)
                .fixedSize()
                .minimumScaleFactor(0.5)
                .allowsTightening(true)

            Button(L10n.Popover.ScreenRec.button) {
                NSWorkspace.shared.open(URL(string: L10n.Popover.ScreenRec.url)!)
            }

            Spacer()
        }
    }

}
