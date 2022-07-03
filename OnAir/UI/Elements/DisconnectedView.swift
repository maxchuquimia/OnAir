//
//  DisconnectedView.swift
//  OnAir
//
//  Created by Max Chuquimia on 15/6/2022.
//

import SwiftUI

struct DisconnectedView: View {

    let text: String

    var body: some View {
        HStack(spacing: 0) {
            ProgressView()
                .scaleEffect(0.5)
                .frame(width: 20, height: 20)
                .progressViewStyle(CircularProgressViewStyle())

            Spacer()
                .frame(width: 6)

            Text(LocalizedStringKey(text))
                .font(.body)
                .allowsTightening(true)
                .minimumScaleFactor(0.7)

            Spacer()
        }
    }

}
