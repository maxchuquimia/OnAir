//
//  UserStatusView.swift
//  OnAir
//
//  Created by Max Chuquimia on 14/6/2022.
//

import SwiftUI

struct UserStatusView: View {

    let state: UserState
    let isEditable: Bool
    let onUsernameChanged: ((String) -> Void)?

    @State var textFieldValue = ""
    @State var isEditing = false
    @FocusState var isFieldFocused: Bool

    var body: some View {
        HStack(spacing: 0) {
            Image(nsImage: state.isOnAir ? Asset.iconOnair.image : Asset.iconConnected.image)
                .resizable()
                .frame(width: 20, height: 20)

            Spacer()
                .frame(width: 6)

            if isEditing {
                TextField(L10n.UserStatus.Field.placeholder, text: $textFieldValue)
                    .textFieldStyle(PlainTextFieldStyle())
                    .fixedSize()
                    .focused($isFieldFocused, equals: true)
                    .onSubmit { stopEditing() }

                Image(systemName: "checkmark")
                    .onTapGesture { stopEditing() }
            } else {
                    if state.isOnAir {
                        Text(state.name)
                            .font(.body) +
                        Text(LocalizedStringKey(L10n.UserStatus.isOnAirSuffix))
                            .font(.body)
                            .foregroundColor(Color(nsColor: NSColor.textColor.withAlphaComponent(0.7)))

                    } else {
                        Text(state.name)
                            .font(.body)
                            .onTapGesture { startEditing() }
                    }
                if isEditable {
                    Spacer()
                        .frame(width: 2)
                    Image(systemName: "square.and.pencil")
                        .onTapGesture { startEditing() }
                }
            }

            Spacer()
        }
        .onAppear {
            textFieldValue = state.name
        }
    }

    private func startEditing() {
        guard isEditable else { return }
        isFieldFocused = true
        isEditing = true
    }

    private func stopEditing() {
        isFieldFocused = false
        isEditing = false
        onUsernameChanged?(textFieldValue)
    }

}
