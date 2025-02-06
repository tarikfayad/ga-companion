//
//  MatchDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/6/25.
//

import SwiftUI

struct MatchDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var match: Match
    let imageSize: CGFloat = 45
    let imageStrokeColor: Color = .white
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var deckHeight: CGFloat = 0
    @State private var heightDiff: CGFloat = 0
    @State private var userChampRows = 0.0
    @State private var opponentChampRows = 0.0
    
    var body: some View {
        VStack {
            Text("DECKS")
                .font(.caption)
            HStack {
                VStack {
                    Text("YOUR DECK")
                        .font(.system(size: 13, weight: .bold, design: .default))
                        .padding(.bottom)
                    
                    Spacer()
                        .frame(height: (userChampRows < opponentChampRows) ? heightDiff/2.0 : 0)
                    
                    let filteredUserChamps = Champion.filterChampionsByLineage(match.userDeck.champions)
                    LazyVGrid(columns: columns, spacing: 5.0) {
                        ForEach(filteredUserChamps.dropLast(filteredUserChamps.count % 2), id: \.self) { champion in
                            Image(champion.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize + 10, height: imageSize + 10)
                                .cornerRadius(imageSize / 2)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    LazyHStack {
                        ForEach(filteredUserChamps.suffix(filteredUserChamps.count % 2), id: \.self) { champion in
                            Image(champion.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize + 10, height: imageSize + 10)
                                .cornerRadius(imageSize / 2)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    HStack {
                        ForEach(match.opponentDeck.elements, id: \.self){ element in
                            Image(element.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize / 2, height: imageSize / 2)
                                .cornerRadius(imageSize / 4)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    Spacer()
                        .frame(height: (userChampRows < opponentChampRows) ? heightDiff/2.0 : 0)
                }.frame(maxWidth: .infinity, maxHeight: deckHeight)
                
                Text("VS")
                    .font(.system(size: 13, weight: .bold, design: .default))
                
                VStack {
                    Text("OPPONENT DECK")
                        .font(.system(size: 13, weight: .bold, design: .default))
                        .padding(.bottom)
                    
                    Spacer()
                        .frame(height: (opponentChampRows < userChampRows) ? heightDiff/2.0 : 0)
                    
                    let filteredOpponentChamps = Champion.filterChampionsByLineage(match.opponentDeck.champions)
                    LazyVGrid(columns: columns, spacing: 5.0) {
                        ForEach(filteredOpponentChamps.dropLast(filteredOpponentChamps.count % 2), id: \.self) { champion in
                            Image(champion.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize + 10, height: imageSize + 10)
                                .cornerRadius(imageSize / 2)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    LazyHStack {
                        ForEach(filteredOpponentChamps.suffix(filteredOpponentChamps.count % 2), id: \.self) { champion in
                            Image(champion.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize + 10, height: imageSize + 10)
                                .cornerRadius(imageSize / 2)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    HStack {
                        ForEach(match.opponentDeck.elements, id: \.self){ element in
                            Image(element.rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize / 2, height: imageSize / 2)
                                .cornerRadius(imageSize / 4)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                    
                    Spacer()
                        .frame(height: (opponentChampRows < userChampRows) ? heightDiff/2.0 : 0)
                }.frame(maxWidth: .infinity, maxHeight: deckHeight)
            }.padding(.bottom, 5)
            
            Divider()
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .overlay(.secondary)
                .padding(.vertical, 5)
            
            if let notes = match.notes, !notes.isEmpty {
                Text("NOTES")
                    .font(.caption)
                Text(notes)
                    .padding([.bottom, .horizontal])
            }
            
            if let playerOneDamageHistory = match.playerOneDamageHistory, !playerOneDamageHistory.isEmpty {
                Text("DAMAGE HISTORY")
                    .font(.caption)
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .overlay(.secondary)
                    .padding(.vertical, 5)
                
                if let playerTwoDamageHistory = match.playerTwoDamageHistory, !playerTwoDamageHistory.isEmpty {
                    HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: playerOneDamageHistory, playerTwoDamageHistory: playerTwoDamageHistory, isLoadingFromMatchHistory: true)
                } else {
                    HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: playerOneDamageHistory, isLoadingFromMatchHistory: true)
                }
            }
            
            Spacer()
            
        }.applyBackground()
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
            
            ToolbarItem(placement: .principal) {
                Text("Match Details")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            calculateDeckHeight()
        }
    }
    
    private func calculateDeckHeight() {
        let filteredUserChamps = Champion.filterChampionsByLineage(match.userDeck.champions)
        let filteredOpponentChamps = Champion.filterChampionsByLineage(match.opponentDeck.champions)

        userChampRows = ceil(Double(filteredUserChamps.count) / 2.0)
        opponentChampRows = ceil(Double(filteredOpponentChamps.count) / 2.0)

        let userDeckHeight = CGFloat(userChampRows) * (imageSize + 10) + 70.0
        let opponentDeckHeight = CGFloat(opponentChampRows) * (imageSize + 10) + 70.0
        
        heightDiff = abs(userDeckHeight - opponentDeckHeight)
        deckHeight = (userDeckHeight > opponentDeckHeight) ? userDeckHeight : opponentDeckHeight
    }
}
