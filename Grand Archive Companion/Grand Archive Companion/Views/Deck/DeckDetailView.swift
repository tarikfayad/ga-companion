//
//  DeckDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI

struct DeckDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var deck: Deck
    
    @State private var cards: [Card] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
            VStack{
                CardPageView(cards: cards) // Pageview of all the Champion cards
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                
                Text("WIN RATE")
                    .font(.caption)
                Text(String(format: "%.2f", Deck.winRate(deck: deck, context: modelContext)))
            }
        }
        .foregroundStyle(.white)
        .onAppear {
            loadChampionCards()
        }
    }
    
    func loadChampionCards() {
        Task {
            isLoading = true
            do {
                for champion in deck.champions {
                    let champ = try await performCardSearch(for: champion.name)
                    cards.append(contentsOf: champ)
                }
            } catch {
                print("Failed to fetch cards: \(error)")
            }
            isLoading = false
        }
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", isUserDeck: true, champions: [playerChampion], elements: [.fire, .crux])
    DeckDetailView(deck: playerDeck)
}
