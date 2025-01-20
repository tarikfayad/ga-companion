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
    @State private var isFirstLaunch: Bool = true
    
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
        ZStack {
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
                                        addDamage(to: &playerTwo, value: count)
                                    },
                                    onDecrementUpdate: { count in
                                        addDamage(to: &playerTwo, value: count)
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
                                    addDamage(to: &playerOne, value: count)
                                },
                                onDecrementUpdate: { count in
                                    addDamage(to: &playerOne, value: count)
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
                                addDamage(to: &playerOne, value: count)
                            },
                            onDecrementUpdate: { count in
                                addDamage(to: &playerOne, value: count)
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
                checkFirstLaunch()
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
            
            if isFirstLaunch {
                if numberOfPlayers == 1 {
                    VStack {
                        HStack {
                            VStack {
                                Image(systemName: "arrow.up.right")
                                    .padding(.bottom, 5)
                                Text("Card Search")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .frame(width: 150, height: 75)
                            .background(Color.black)
                            Spacer()
                                .frame(width: 40)
                            VStack {
                                Image(systemName: "arrow.up.backward")
                                    .padding(.bottom, 5)
                                Text("Damage History")
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .frame(width: 160, height: 75)
                            .background(Color.black)
                        }.padding(.top, 70)
                        Spacer()
                        VStack {
                            Text("Token Menu")
                                .font(.system(size: 20, weight: .bold))
                            Text("Open to add a token counter.\nSingle Tap to increment a token.\nDouble tap to decrement it.\nLong press to remove it.")
                                .frame(width: 250)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                            Image(systemName: "arrow.down")
                        }
                        .frame(width: 250, height: 150)
                        .background(Color.black)
                        .padding(.bottom, 100)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .foregroundStyle(.white)
                    .contentShape(Rectangle())
                    .background(Color.black.opacity(0.3))
                    .onTapGesture {isFirstLaunch = false}
                    .animation(.easeInOut(duration: 0.3), value: isFirstLaunch)
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            VStack {
                                Text("Card Search")
                                    .font(.system(size: 20, weight: .bold))
                                Image(systemName: "arrow.down.right")
                                    .padding(.top, 5)
                            }
                            .frame(width: 150, height: 75)
                            .background(Color.black)
                            Spacer()
                                .frame(width: 40)
                            VStack {
                                Text("Damage History")
                                    .font(.system(size: 20, weight: .bold))
                                Image(systemName: "arrow.down.backward")
                                    .padding(.top, 5)
                            }
                            .frame(width: 160, height: 75)
                            .background(Color.black)
                        }.padding(.top, 70)
                        Spacer()
                        VStack {
                            Text("Token Menu")
                                .font(.system(size: 20, weight: .bold))
                            Text("Open to add a token counter.\nSingle Tap to increment a token.\nDouble tap to decrement it.\nLong press to remove it.")
                                .font(.system(size: 15))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                            Image(systemName: "arrow.down")
                        }.frame(width: 250, height: 150)
                        .background(Color.black)
                        .padding(.bottom, 100)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .foregroundStyle(.white)
                    .contentShape(Rectangle())
                    .background(Color.black.opacity(0.3))
                    .onTapGesture {isFirstLaunch = false}
                    .animation(.easeInOut(duration: 0.3), value: isFirstLaunch)
                }
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
    
    private func addDamage(to player: inout Player, value: Int) {
        let damage = Damage(player: player, value: value, sortIndex: retrieveHighestSortIndex(player: player) + 1)
        player.damageHistory.append(damage)
    }
    
    private func retrieveHighestSortIndex(player: Player) -> Int {
        return player.damageHistory.max(by: { $0.sortIndex < $1.sortIndex })?.sortIndex ?? 0
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedKey = "hasLaunchedBefore"

        if !UserDefaults.standard.bool(forKey: hasLaunchedKey) {
            // First launch
            isFirstLaunch = true
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
        } else {
            // Not the first launch
            isFirstLaunch = false
        }
    }
}

#Preview ("One Player") {
    CounterView(numberOfPlayers: 1)
}

#Preview ("Two Players") {
    CounterView(numberOfPlayers: 2)
}
