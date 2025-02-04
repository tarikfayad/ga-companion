//
//  DeckDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI

struct DeckDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var deck: Deck
    
    @State private var cards: [Card] = []
    @State private var isLoading: Bool = false
    @State private var matches: [Match] = []
    @State private var playedChampions: [Champion] = []
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
            VStack{
                if isLoading {
                    ProgressView("Loading Champion Images")
                } else {
                    CardPageView(cards: cards) // Pageview of all the Champion cards
                        .frame(width: UIScreen.main.bounds.width * 0.75)
                }
                
                Text("WIN RATE")
                    .font(.caption)
                Text(String(format: "%.2f", Deck.winRate(deck: deck, context: modelContext)))
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(playedChampions, id: \.id) { champion in
                            LineageWinRateView(champion: champion, winRate: Deck.winRate(deck: deck, champion: champion, context: modelContext), imageSize: 75)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .onAppear {
            loadChampionCards()
            matches = Match.loadMatchesForDeck(deck, context: modelContext)
            playedChampions = Deck.getAllPlayedChampions(deck: deck, context: modelContext)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
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
                Text(deck.name)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
    NavigationStack {
        DeckDetailView(deck: playerDeck)
    }
}
