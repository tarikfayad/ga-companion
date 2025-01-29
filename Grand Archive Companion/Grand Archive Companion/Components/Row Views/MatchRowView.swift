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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack {
                    ZStack {
                        Image(match.userDeck.champion.imageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize + 10, height: imageSize + 10)
                            .cornerRadius(imageSize / 2)
                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        
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
                .frame(minWidth: 110)
                .padding(.trailing, 10)
                
                Text("vs")
                
                HStack {
                    ZStack {
                        Image(match.opponentDeck.champion.imageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize + 10, height: imageSize + 10)
                            .cornerRadius(imageSize / 2)
                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 2))
                        
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
                .frame(minWidth: 110)
                .padding(.leading, 10)
                Spacer()
            }
            HStack {
                Spacer()
                Text(match.didUserWin ? "WIN" : "LOSE")
                    .foregroundStyle(match.didUserWin ? .green : .red)
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", champion: playerChampion, elements: [.fire, .crux])
    
    let opponentChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let opponentDeck = Deck(name: "Deck 1", champion: opponentChampion, elements: [.fire, .crux])
    
    let match = Match.init(didUserWin: true, userDeck: playerDeck, opponentDeck: opponentDeck)
        
    List(0..<5) { item in
        MatchRowView(match: match)
            .listRowBackground(Color.background)
    }
    .scrollContentBackground(.hidden)
    .background(Color.background)
}
