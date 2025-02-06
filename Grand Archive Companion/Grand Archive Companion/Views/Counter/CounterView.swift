//
//  CounterView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI
import SwiftData

// Extension methods to detect devie shake.
extension Notification.Name {
    static let navigateBackToPlayers = Notification.Name("navigateBackToPlayers")
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)){ _ in
                action()
            }
    }
}

extension View {
    func onDeviceShake(_ action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

struct CounterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @State private var isFirstLaunch: Bool = true
    @State private var showResetMenu: Bool = false
    @State private var notificationRecieved: Bool = false
    
    @Query private var players: [Player] // Fetch all Player models
    
    @State var numberOfPlayers: Int
    @State private var playerOne: Player
    @State private var playerTwo: Player
    
    @State private var navigateToCardSearchView = false
    @State private var navigateToHistoryView = false
    @State private var navigateToAddMatchView = false
    
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
                                    player: playerTwo,
                                    isSinglePlayer: false,
                                    isTopPlayer: true
                                )
                                .rotationEffect(.degrees(180))
                                .ignoresSafeArea(.all)
                            }
                            PlayerCounterView (
                                backgroundColor: .playerBlue,
                                fontColor: .white,
                                player: playerOne,
                                isSinglePlayer: false
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
                                
                                CircleButtonView(imageName: "square.and.arrow.down.fill", tintColor: Color.black, padding: 10, buttonSize: 30){
                                    navigateToAddMatchView = true
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
                            player: playerOne
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
                                CircleButtonView(imageName: "square.and.arrow.down.fill", tintColor: Color.black, padding: 10, buttonSize: 30){
                                    navigateToAddMatchView = true
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
                UIApplication.shared.isIdleTimerDisabled = true // Screen will stay awake while on this screen
                NotificationCenter.default.addObserver(forName: .navigateBackToPlayers, object: nil, queue: .main) { _ in
                        // Ensure CounterView is still the active view before dismissing
                        if !notificationRecieved {
                            notificationRecieved = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false // Screen will no longer stay awake after leaving this screen
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
            .navigationDestination(isPresented: $navigateToAddMatchView) {
                if numberOfPlayers > 1 {
                    AddMatchView(comingFromCounter: true, playerOneDamageHistory: playerOne.damageHistory, playerTwoDamageHistory: playerTwo.damageHistory)
                } else {
                    AddMatchView(comingFromCounter: true, playerOneDamageHistory: playerOne.damageHistory)
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
        .onDeviceShake {
            showResetMenu.toggle()
        }
        .alert("New Game?", isPresented: $showResetMenu) {
            Button {
                resetGame()
            } label:{
                Text("Reset")
            }.padding()
            
            Button(role: .cancel) {
            } label:{
                Text("Cancel")
            }.padding()
        } message: {
            Text("Would you like to erase all history and reset the game?")
        }
        
    }
    
    // Helper methods for view setup.
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
    
    private func resetGame() {
        Player.deleteAll(context: modelContext)
        setupPlayers()
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
