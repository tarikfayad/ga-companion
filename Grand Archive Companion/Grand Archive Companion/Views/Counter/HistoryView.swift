//
//  HistoryView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/19/25.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var multiplayer: Bool
    var playerOneColor: Color
    var playerTwoColor: Color?
    
    var playerOneDamageHistory: [Damage] = []
    @State var playerOneHistory: [String] = []
    
    var playerTwoDamageHistory: [Damage] = []
    @State var playerTwoHistory: [String] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background.ignoresSafeArea(.all)
                
                let singlePlayerWidth = max(geometry.size.width - 20, 0)
                let multiplayerWidth = max(geometry.size.width / 2 - 15, 0)
                
                VStack {
                    HStack {
                        Text("Player 1")
                            .frame(width: multiplayer ? multiplayerWidth : singlePlayerWidth, height: 35)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .background(playerOneColor)
                        
                        if multiplayer {
                            Text("Player 2")
                                .frame(width: multiplayerWidth, height: 35)
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .background(playerTwoColor)
                        }
                    }
                    .frame(maxHeight: 36)
                    .foregroundStyle(.white)
                    
                    HStack {
                        List {
                            ForEach(playerOneHistory, id: \.self) { item in
                                Text(item)
                                    .frame(height: 35)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .listRowInsets(EdgeInsets())
                                    .background(playerOneColor)
                                    .padding(.vertical, 5)
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .foregroundStyle(.white)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .frame(width: multiplayer ? multiplayerWidth : singlePlayerWidth)
                        .listStyle(PlainListStyle())
                        
                        if multiplayer {
                            List {
                                ForEach(playerTwoHistory, id: \.self) { item in
                                    Text(item)
                                        .frame(height: 35)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .listRowInsets(EdgeInsets())
                                        .background(playerTwoColor)
                                        .padding(.vertical, 5)
                                        .font(.system(size: 20, weight: .bold, design: .default))
                                        .foregroundStyle(.white)
                                }
                                .listRowBackground(Color.clear)
                            }
                            .frame(width: multiplayerWidth)
                            .listStyle(PlainListStyle())
                        }
                    }
                    
                    CircleButtonView(imageName: "xmark", tintColor: .black, padding: 15, buttonSize: 20){dismiss()}
                }
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            generatePlayerOneHistoryStrings()
            generatePlayerTwoHistoryStrings()
        }
    }
    
    // MARK: - Helper Functions
    private func generatePlayerOneHistoryStrings() {
        var playerDamage = 0
        var history = playerOneDamageHistory
        history.sort { $0.sortIndex < $1.sortIndex }
        for damage in history {
            playerDamage += damage.value
            playerOneHistory.append("\(playerDamage) (\(damage.value > 0 ? "+\(damage.value)" : "\(damage.value)"))")
        }
    }
    
    private func generatePlayerTwoHistoryStrings() {
        var playerDamage = 0
        var history = playerTwoDamageHistory
        history.sort { $0.sortIndex < $1.sortIndex }
        for damage in history {
            playerDamage += damage.value
            playerTwoHistory.append("\(playerDamage) (\(damage.value > 0 ? "+\(damage.value)" : "\(damage.value)"))")
        }
    }
}

#Preview("One Player") {
    createOnePlayerPreview()
}

#Preview("Two Players") {
    createTwoPlayersPreview()
}

// MARK: - Preview Helper Functions
func createOnePlayerPreview() -> some View {
    let playerOne = Player(index: 1)
    let damageHistory: [Damage] = [
        Damage(player: playerOne, value: 1, sortIndex: 0),
        Damage(player: playerOne, value: 1, sortIndex: 3),
        Damage(player: playerOne, value: 5, sortIndex: 2),
    ]
    playerOne.damageHistory = damageHistory

    return HistoryView(
        multiplayer: false,
        playerOneColor: .playerBlue,
        playerOneDamageHistory: damageHistory
    )
}

func createTwoPlayersPreview() -> some View {
    let playerOne = Player(index: 1)
    let playerTwo = Player(index: 2)

    let damageHistoryOne: [Damage] = [
        Damage(player: playerOne, value: 1, sortIndex: 0),
        Damage(player: playerOne, value: 1, sortIndex: 3),
        Damage(player: playerOne, value: 5, sortIndex: 2),
    ]
    playerOne.damageHistory = damageHistoryOne

    let damageHistoryTwo: [Damage] = [
        Damage(player: playerTwo, value: 2, sortIndex: 1),
        Damage(player: playerTwo, value: 4, sortIndex: 4),
        Damage(player: playerTwo, value: 3, sortIndex: 5),
    ]
    playerTwo.damageHistory = damageHistoryTwo

    return HistoryView(
        multiplayer: true,
        playerOneColor: .playerBlue,
        playerTwoColor: .playerPink,
        playerOneDamageHistory: damageHistoryOne,
        playerTwoDamageHistory: damageHistoryTwo
    )
}
