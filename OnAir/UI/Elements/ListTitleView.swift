//
//  ListTitleView.swift
//  OnAir
//
//  Created by Max Chuquimia on 15/6/2022.
//

import SwiftUI

struct ListTitleView: View {

    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Color.gray
                .opacity(0.5)
                .frame(width: 20, height: 1)
            Text(title.capitalized)
                .lineLimit(1)
                .layoutPriority(.greatestFiniteMagnitude)
                .foregroundColor(.gray)
                .opacity(0.5)
                .font(.subheadline)
            Color.gray
                .opacity(0.5)
                .frame(height: 1)
        }
    }

}
