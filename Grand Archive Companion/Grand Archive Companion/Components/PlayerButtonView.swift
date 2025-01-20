//
//  PlayerButtonView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct PlayerButtonView: View {
    @State var playerNumber: Int
    @State var tintColor: Color = .blue
    var onButtonTap: () -> Void
    
    var body: some View {
        Button {
            onButtonTap()
        } label: {
            Text("\(playerNumber)")
                .font(.custom("Helvetica-Bold", size: 64))
                .frame(width: 128, height: 158)
        }.buttonStyle(.borderedProminent)
            .tint(tintColor)
    }
}

#Preview {
    PlayerButtonView(playerNumber: 2) {
        print("2 players button tapped")
    }
}
