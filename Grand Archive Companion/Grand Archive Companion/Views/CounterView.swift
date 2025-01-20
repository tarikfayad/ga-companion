//
//  CounterView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [Player] // Fetch all Player models
    
    @State var numberOfPlayers: Int
    @State private var playerOne: Player
    @State private var playerTwo: Player
    
    @State private var navigateToCardSearchView = false
    @State private var navigateToHistoryView = false
    
    init(numberOfPlayers: Int) {
        _numberOfPlayers = State(initialValue: numberOfPlayers)

            // Temporary placeholder for @State properties
        let placeholderPlayer = Player(index: 0)
        _playerOne = State(initialValue: placeholderPlayer)
        _playerTwo = State(initialValue: placeholderPlayer)
    }
    
    var body: some View {
        
        VStack {
            if numberOfPlayers > 1 {
                ZStack {
                    VStack {
                        ZStack {
                            PlayerCounterView (
                                backgroundColor: .playerPink,
                                fontColor: .white,
                                player: $playerTwo,
                                isSinglePlayer: false,
                                isTopPlayer: true,
                                onIncrementUpdate: { count in
                                    let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerTwo)+1)
                                    playerTwo.damageHistory.append(damage)
                                },
                                onDecrementUpdate: { count in
                                    let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerTwo)+1)
                                    playerTwo.damageHistory.append(damage)
                                }
                            )
                            .rotationEffect(.degrees(180))
                            .ignoresSafeArea(.all)
                        }
                        PlayerCounterView (
                            backgroundColor: .playerBlue,
                            fontColor: .white,
                            player: $playerOne,
                            isSinglePlayer: false,
                            onIncrementUpdate: { count in
                                let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerOne)+1)
                                playerOne.damageHistory.append(damage)
                            },
                            onDecrementUpdate: { count in
                                let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerOne)+1)
                                playerOne.damageHistory.append(damage)
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
                        player: $playerOne,
                        onIncrementUpdate: { count in
                            let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerOne)+1)
                            playerOne.damageHistory.append(damage)
                        },
                        onDecrementUpdate: { count in
                            let damage = Damage(value: count, sortIndex:retrieveHighestSortIndex(player: playerOne)+1)
                            playerOne.damageHistory.append(damage)
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
        .onAppear {
            setupPlayers()
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToCardSearchView) {
            CardSearchView()
        }
        .navigationDestination(isPresented: $navigateToHistoryView) {
            if numberOfPlayers == 1 {
                HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: playerOne.damageHistory)
            } else {
                HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: playerOne.damageHistory, playerTwoDamageHistory: playerTwo.damageHistory)
            }
        }
    }
    
    private func setupPlayers() {
        // Load all players from the context
        let fetchedPlayers = Player.load(context: modelContext)

        // Check for Player One
        if let existingPlayerOne = fetchedPlayers.first(where: { $0.index == 1 }) {
            playerOne = existingPlayerOne
        } else {
            let newPlayerOne = Player(index: 1)
            Player.save(players: [newPlayerOne], context: modelContext)
            playerOne = newPlayerOne
        }

        // Check for Player Two if there is more than one player playing
        if numberOfPlayers > 1 {
            if let existingPlayerTwo = fetchedPlayers.first(where: { $0.index == 2 }) {
                playerTwo = existingPlayerTwo
            } else {
                let newPlayerTwo = Player(index: 2)
                Player.save(players: [newPlayerTwo], context: modelContext)
                playerTwo = newPlayerTwo
            }
        }
    }
    
    private func retrieveHighestSortIndex(player: Player) -> Int {
        return player.damageHistory.max(by: { $0.sortIndex < $1.sortIndex })?.sortIndex ?? 0
    }
}

#Preview ("One Player") {
    CounterView(numberOfPlayers: 1)
}

#Preview ("Two Players") {
    CounterView(numberOfPlayers: 2)
}
