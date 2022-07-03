//
//  MessageView.swift
//  OnAir
//
//  Created by Max Chuquimia on 18/6/2022.
//

import SwiftUI

struct FriendlyMessageView: View {

    @EnvironmentObject private var metaInfo: MetaInfoUI

    var body: some View {
        ZStack {
            Color(nsColor: metaInfo.isSomeoneOnAir ? Asset.oaRed.color : Asset.oaGreen.color)
                .scaleEffect(1.5, anchor: .bottom)
            Text(LocalizedStringKey(metaInfo.friendlyMessage))
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(.white)
                .allowsTightening(true)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
        }
        .frame(height: 40)
    }

}
