//
//  SelectPlayersView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct SelectPlayersView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
            VStack {
                Text("Players")
                    .font(.system(size: 50, weight: .heavy))
                    .padding(.bottom, 5)
                Text("Set the number of players.")
                    .font(.system(size: 20))
                    .padding(.bottom, 30)
                
                HStack {
                    PlayerButtonView(playerNumber: 1){}
                    PlayerButtonView(playerNumber: 2){}
                }
                
                HStack {
                    PlayerButtonView(playerNumber: 3){}
                    PlayerButtonView(playerNumber: 4){}
                }
            }.foregroundStyle(.white)
        }
    }
}

#Preview {
    SelectPlayersView()
}
