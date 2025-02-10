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
    @State var selectedChampion: Champion?
    @State var selectedMatch: Match?
    
    @State private var cards: [Card] = []
    @State private var champsLoaded: Bool = false
    @State private var matches: [Match] = []
    @State private var filteredMatches: [Match] = []
    @State private var playedChampions: [Champion] = []
    @State private var navigateToMatchDetails: Bool = false
    @State private var navigateToDeckList: Bool = false
    
    var body: some View {
        ScrollView {
            VStack{
                Text("CHAMPIONS")
                    .font(.caption)
                CardPageView(cards: cards) // Pageview of all the Champion cards
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.width * 0.75 * 1.36)
                
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .overlay(.secondary)
                    .padding(.vertical, 5)
                
                Text("WIN RATE")
                    .font(.caption)
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 5) // Background ring
                    Circle()
                        .trim(from: 0, to: CGFloat(Deck.winRate(deck: deck, context: modelContext) / 100))
                        .stroke(.playerYellow, lineWidth: 5) // Win rate progress
                        .rotationEffect(.degrees(-90))
                    Text(String(format: "%.0f%%", Deck.winRate(deck: deck, context: modelContext)))
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                .frame(width: 40, height: 40)
                .onTapGesture {
                    filterMatchesByChampion(champion: nil)
                }
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(playedChampions, id: \.id) { champion in
                            LineageWinRateView(champion: champion, winRate: Deck.winRate(deck: deck, champion: champion, context: modelContext), imageSize: 70, isSelected: isSelected(champion: champion)) { champion in
                                filterMatchesByChampion(champion: champion)
                            }
                                .padding(.horizontal, 5)
                        }
                    }
                    .frame(height: 100)
                }.padding(.bottom, 10)
                
                Text("MATCHES")
                    .font(.caption)
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .overlay(.secondary)
                    .padding(.vertical, 5)
                List {
                    ForEach(filteredMatches, id: \.id) { match in
                        MatchRowView(match: match) { match in
                            selectedMatch = match
                            navigateToMatchDetails = true
                        }
                        .listRowBackground(Color.background)
                    }
                    .onDelete(perform: deleteMatch)
                }
                .frame(minHeight: 300, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Color.background)
                .listStyle(.plain)
                .padding(.horizontal, 0)
            }
        }
        .applyBackground()
        .foregroundStyle(.white)
        .onAppear {
            if !champsLoaded {
                champsLoaded = true // Stopping champs from double loading when popping match details
                loadChampionCards()
            }
            matches = Match.loadMatchesForDeck(deck, context: modelContext).reversed() // Putting the most recent matches at the top
            filteredMatches = matches
            playedChampions = Deck.getAllPlayedChampions(deck: deck, context: modelContext)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
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
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    navigateToDeckList = true
                }) {
                    HStack {
                        Image("card_back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } .foregroundStyle(.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToMatchDetails) {
            if let selectedMatch = selectedMatch {
                MatchDetailView(match: selectedMatch)
            }
        }
        .navigationDestination(isPresented: $navigateToDeckList) {
            DeckListView()
        }
    }
    
    private func loadChampionCards() {
        Task {
            do {
                for champion in deck.champions {
                    let champ = try await performCardSearch(for: champion.name)
                    cards.append(contentsOf: champ)
                }
            } catch {
                print("Failed to fetch cards: \(error)")
            }
        }
    }
    
    private func filterMatchesByChampion(champion: Champion?) {
        selectedChampion = champion
        if let champion = champion { // Safely unwrap
            filteredMatches = matches.filter { match in
                match.opponentDeck.champions.contains { opponentChampion in
                    opponentChampion.name == champion.name
                }
            }
        } else {
            filteredMatches = matches
        }
    }
    
    private func isSelected(champion: Champion) -> Bool {
        return champion == selectedChampion
    }
    
    private func deleteMatch(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let match = filteredMatches[index]
        filteredMatches.remove(atOffsets: offsets)
        matches.removeAll(where: { $0.id == match.id })
        Match.delete(match: match, context: modelContext)
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", isUserDeck: true, champions: [playerChampion], elements: [.fire, .crux])
    NavigationStack {
        DeckDetailView(deck: playerDeck)
    }
}
