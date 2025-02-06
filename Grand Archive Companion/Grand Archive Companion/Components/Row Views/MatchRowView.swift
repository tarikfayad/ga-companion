//
//  MatchRowView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import SwiftUI

struct MatchRowView: View {
    @State var match: Match
    let imageSize: CGFloat = 45
    let imageStrokeColor: Color = .white
    let onTap: (Match) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    HStack {
                        ZStack {
                            let filteredChamps = Champion.filterChampionsByLineage(match.userDeck.champions)
                            
                            if filteredChamps.count > 2 {
                                VStack {
                                    HStack {
                                        ForEach(filteredChamps.prefix(2), id: \.self){ champion in
                                            Image(champion.imageName())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: imageSize - 10, height: imageSize - 10)
                                                .cornerRadius(imageSize / 2)
                                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                        }
                                    }
                                    
                                    HStack {
                                        ForEach(filteredChamps.dropFirst(2), id: \.self){ champion in
                                            Image(champion.imageName())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: imageSize - 10, height: imageSize - 10)
                                                .cornerRadius(imageSize / 2)
                                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                        }
                                    }
                                }
                            } else {
                                HStack {
                                    ForEach(filteredChamps, id: \.self){ champion in
                                        Image(champion.imageName())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: imageSize + 10, height: imageSize + 10)
                                            .cornerRadius(imageSize / 2)
                                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                    }
                                }
                            }
                            
                            VStack {
                                Spacer()
                                HStack {
                                    ForEach(match.userDeck.elements, id: \.self){ element in
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
                    }
                    .frame(minWidth: 100)
                    .padding(.trailing, 10)
                    
                    Text(match.userDeck.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    Spacer()
                    Text("vs")
                    Text(match.didUserWin ? "WIN" : "LOSE")
                        .foregroundStyle(match.didUserWin ? .green : .red)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        ZStack {
                            let filteredChamps = Champion.filterChampionsByLineage(match.opponentDeck.champions)
                            
                            if filteredChamps.count > 2 {
                                VStack {
                                    HStack {
                                        ForEach(filteredChamps.prefix(2), id: \.self){ champion in
                                            Image(champion.imageName())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: imageSize - 10, height: imageSize - 10)
                                                .cornerRadius(imageSize / 2)
                                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                        }
                                    }
                                    
                                    HStack {
                                        ForEach(filteredChamps.dropFirst(2), id: \.self){ champion in
                                            Image(champion.imageName())
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: imageSize - 10, height: imageSize - 10)
                                                .cornerRadius(imageSize / 2)
                                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                        }
                                    }
                                }
                            } else {
                                HStack {
                                    ForEach(filteredChamps, id: \.self){ champion in
                                        Image(champion.imageName())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: imageSize + 10, height: imageSize + 10)
                                            .cornerRadius(imageSize / 2)
                                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                                    }
                                }
                            }
                            
                            VStack {
                                Spacer()
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
                    }
                    .frame(minWidth: 100)
                    .padding(.leading, 10)
                    
                    Text(match.opponentDeck.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .onTapGesture { onTap(match) }
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", isUserDeck: true, champions: [playerChampion], elements: [.fire, .crux])
    
    let opponentChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let opponentDeck = Deck(name: "Deck 1", isUserDeck: false, champions: [opponentChampion], elements: [.fire, .crux])
    
    let match = Match.init(didUserWin: true, userDeck: playerDeck, opponentDeck: opponentDeck)
        
    List(0..<5) { item in
        MatchRowView(match: match){ _ in }
            .listRowBackground(Color.background)
    }
    .scrollContentBackground(.hidden)
    .background(Color.background)
}
