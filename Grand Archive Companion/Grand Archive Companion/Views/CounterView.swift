//
//  CounterView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct CounterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var numberOfPlayers: Int
    
    @State private var playerOneHistory: [Int] = []
    @State private var playerTwoHistory: [Int] = []
    
    @State private var navigateToCardSearchView = false
    @State private var navigateToHistoryView = false
    
    var body: some View {
        
        VStack {
            if numberOfPlayers > 1 {
                ZStack {
                    VStack {
                        ZStack {
                            PlayerCounterView (
                                backgroundColor: .playerPink,
                                fontColor: .white,
                                isSinglePlayer: false,
                                isTopPlayer: true,
                                onIncrementUpdate: { count in
                                    playerTwoHistory.append(count)
                                },
                                onDecrementUpdate: { count in
                                    playerTwoHistory.append(count)
                                }
                            )
                            .rotationEffect(.degrees(180))
                            .ignoresSafeArea(.all)
                        }
                        PlayerCounterView (
                            backgroundColor: .playerBlue,
                            fontColor: .white,
                            isSinglePlayer: false,
                            onIncrementUpdate: { count in
                                playerOneHistory.append(count)
                            },
                            onDecrementUpdate: { count in
                                playerOneHistory.append(count)
                            }
                        )
                    }
                    VStack {
                        HStack {
                            CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black, padding: 15, buttonSize: 20){
                                navigateToCardSearchView = true
                            }
                            
                            CircleButtonView(imageName: "arrow.counterclockwise.circle", tintColor: Color.black, padding: 10, buttonSize: 30){
                                navigateToHistoryView = true
                            }
                        }
                    }
                    
                    HStack {
                        VStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward") // Custom back icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                } .foregroundStyle(.white)
                            }
                            .padding([.leading, .top])
                            Spacer()
                        }
                        Spacer()
                    }
                }
            } else {
                ZStack {
                    PlayerCounterView (
                        backgroundColor: .playerBlue,
                        fontColor: .white,
                        onIncrementUpdate: { count in
                            playerOneHistory.append(count)
                        },
                        onDecrementUpdate: { count in
                            playerOneHistory.append(count)
                        }
                    )
                    .padding(.top, -20)
                    
                    VStack {
                        HStack {
                            CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black, padding: 15, buttonSize: 20){
                                navigateToCardSearchView = true
                            }
                            CircleButtonView(imageName: "arrow.counterclockwise.circle", tintColor: Color.black, padding: 10, buttonSize: 30){
                                navigateToHistoryView = true
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward") // Custom back icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                } .foregroundStyle(.white)
                            }
                            .padding([.leading, .top])
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToCardSearchView) {
            CardSearchView()
        }
        .navigationDestination(isPresented: $navigateToHistoryView) {
            if numberOfPlayers == 1 {
                HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: playerOneHistory)
            } else {
                HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: playerOneHistory, playerTwoDamageHistory: playerTwoHistory)
            }
        }
    }
    
}

#Preview ("One Player") {
    CounterView(numberOfPlayers: 1)
}

#Preview ("Two Players") {
    CounterView(numberOfPlayers: 2)
}
