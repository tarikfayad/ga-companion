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
                        numberOfPlayers = 1
                        if Player.arePlayersSaved(context: modelContext) {
                            showNewGameSheet = true
                        } else {navigateToPlayerView = true}
                    }
                    PlayerButtonView(playerNumber: 2, tintColor: .playerPink){
                        numberOfPlayers = 2
                        if Player.arePlayersSaved(context: modelContext) {
                            showNewGameSheet = true
                        } else {navigateToPlayerView = true}
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
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .alert("Start a New Game?", isPresented: $showNewGameSheet) {
            Text("It looks like you had a game in progress.\nWould you like to start a new one or load the previous one?")
            Button {
                Player.deleteAll(context: modelContext)
                navigateToPlayerView = true
            } label:{
                Text("New Game")
            }.padding()
            
            Button {
                navigateToPlayerView = true
            } label:{
                Text("Load Game")
            }.padding()
        }
    }
}

#Preview {
    SelectPlayersView()
}
