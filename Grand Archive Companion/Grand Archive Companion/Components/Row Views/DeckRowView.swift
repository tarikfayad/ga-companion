//
//  DeckRowView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI

struct DeckRowView: View {
    @State var deck: Deck
    @Environment(\.modelContext) private var modelContext
    
    var imageStrokeColor: Color = .white
    
    var body: some View {
        ZStack {
            HStack {
                let filteredChamps = Champion.filterChampionsByLineage(deck.champions)
                
                if filteredChamps.count > 2 {
                    VStack {
                        HStack {
                            ForEach(filteredChamps.prefix(2), id: \.self) { champion in
                                Image(champion.imageName())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                    .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                            }
                        }
                        HStack {
                            ForEach(filteredChamps.dropFirst(2), id: \.self) { champion in
                                Image(champion.imageName())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                    .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                            }
                        }
                    }
                } else {
                    HStack {
                        ForEach(filteredChamps, id: \.self) { champion in
                            Image(champion.imageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: filteredChamps.count == 2 ? 35 : 65, height: filteredChamps.count == 2 ? 30 : 65)
                                .cornerRadius(filteredChamps.count == 2 ? 17.5 : 32.5)
                                .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text(deck.name)
                        Spacer()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 4)
                    
                    HStack {
                        Text(deck.elements.map(\.rawValue).joined(separator: " / "))
                        Text("•")
                        Text(String(Deck.winRate(deck: deck, context: modelContext)) + "%")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }.frame(minHeight: 60)
        }.foregroundStyle(.black)
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", isUserDeck: true, champions: [playerChampion], elements: [.fire, .crux])
    
    List(0..<5) { item in
        DeckRowView(deck: playerDeck)
    }
}
