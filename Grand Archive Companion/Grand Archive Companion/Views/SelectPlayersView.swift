//
//  SelectPlayersView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct SelectPlayersView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var showNewGameSheet = false
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
                    PlayerButtonView(playerNumber: 1, tintColor: .playerBlue){
                        // If the user selects a new session, erase the old one.
                        Player.deleteAll(context: modelContext)
                        numberOfPlayers = 1
                        navigateToPlayerView = true
                    }
                    PlayerButtonView(playerNumber: 2, tintColor: .playerPink){
                        // If the user selects a new session, erase the old one.
                        Player.deleteAll(context: modelContext)
                        numberOfPlayers = 2
                        navigateToPlayerView = true
                    }
                }
                
                // If there's a previous session saved, give the user the option to load it.
                let playerCheck = Player.arePlayersSaved(context: modelContext)
                Button {
                    numberOfPlayers = playerCheck.number
                    navigateToPlayerView = true
                } label: {
                    Text("Load Last Session")
                        .frame(width: 175, height: 35)
                        .cornerRadius(25)
                        .foregroundStyle(Color.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .padding(.top, 30)
                .opacity(playerCheck.boolean ? 1 : 0)
                .disabled(!playerCheck.boolean)
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
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    SelectPlayersView()
}
