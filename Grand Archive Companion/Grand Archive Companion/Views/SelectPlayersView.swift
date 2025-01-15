//
//  SelectPlayersView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct SelectPlayersView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var navigateToPlayerView = false
    @State private var numberOfPlayers: Int = 1
    
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
                    PlayerButtonView(playerNumber: 1){
                        numberOfPlayers = 1
                        navigateToPlayerView = true
                    }
                    PlayerButtonView(playerNumber: 2){
                        numberOfPlayers = 2
                        navigateToPlayerView = true
                    }
                }
            }.foregroundStyle(.white)
        }
        .navigationDestination(isPresented: $navigateToPlayerView) {
            CounterView(numberOfPlayers: numberOfPlayers)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back
                }) {
                    HStack {
                        Image(systemName: "arrow.backward") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    SelectPlayersView()
}
