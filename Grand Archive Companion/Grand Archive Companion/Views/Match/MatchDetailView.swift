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
    let columns = [GridItem(.fixed(55)), GridItem(.fixed(55))]
    
    @State private var deckHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView {
                Text("DECKS")
                    .font(.caption)
                HStack {
                    VStack {
                        Text("YOUR DECK")
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .padding(.bottom)
                        
                        VStack {
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
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: deckHeight)
                    
                    Text("VS")
                        .font(.system(size: 13, weight: .bold, design: .default))
                    
                    VStack {
                        Text("OPPONENT DECK")
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .padding(.bottom)
                        
                        VStack {
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
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: deckHeight)
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
                
                if let playerOneDamageHistory = match.playerOneDamageHistory {
                    Text("DAMAGE HISTORY")
                        .font(.caption)
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.5)
                        .overlay(.secondary)
                        .padding(.vertical, 5)
                    
                    if let playerTwoDamageHistory = match.playerTwoDamageHistory {
                        HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: playerOneDamageHistory, playerTwoDamageHistory: playerTwoDamageHistory, isLoadingFromMatchHistory: true)
                            .frame(minHeight: 300, maxHeight: 800)
                    } else {
                        HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: playerOneDamageHistory, isLoadingFromMatchHistory: true)
                            .frame(minHeight: 300, maxHeight: 800)
                    }
                }
                
                Spacer()
            }
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

        let userChampRows = ceil(Double(filteredUserChamps.count) / 2.0)
        let opponentChampRows = ceil(Double(filteredOpponentChamps.count) / 2.0)

        let userDeckHeight = CGFloat(userChampRows) * (imageSize + 10) + 70.0
        let opponentDeckHeight = CGFloat(opponentChampRows) * (imageSize + 10) + 70.0
        
        deckHeight = (userDeckHeight > opponentDeckHeight) ? userDeckHeight : opponentDeckHeight
    }
}
