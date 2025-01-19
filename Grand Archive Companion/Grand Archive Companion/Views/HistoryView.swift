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
    
    var playerOneDamageHistory: [Int] = []
    @State var playerOneHistory: [String] = []
    
    var playerTwoDamageHistory: [Int] = []
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
        for damage in playerOneDamageHistory {
            playerDamage += damage
            playerOneHistory.append("\(playerDamage) (\(damage > 0 ? "+\(damage)" : "\(damage)"))")
        }
    }
    
    private func generatePlayerTwoHistoryStrings() {
        var playerDamage = 0
        for damage in playerTwoDamageHistory {
            playerDamage += damage
            playerTwoHistory.append("\(playerDamage) (\(damage > 0 ? "+\(damage)" : "\(damage)"))")
        }
    }
}

#Preview("One Player") {
    HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: [1, 2, -5, 4])
}

#Preview("Two Players") {
    HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: [1, 2, -5, 4], playerTwoDamageHistory: [10, 20, -15, 12])
}
