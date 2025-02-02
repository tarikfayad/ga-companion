//
//  DeckHistoryView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import SwiftUI

struct DeckHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State var matches: [Match] = []
    @State var filteredMatches: [Match] = []
    @State var decks: [Deck] = []
    
    @State private var menuTitle: String = "Filter by Deck"
    @State private var selectedDeck: Deck?
    @State private var navigateToCreateMatchView = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background.ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Menu(menuTitle) {
                        Button("Clear Filter") {
                            menuTitle = "Filter by Deck"
                            filteredMatches = matches
                        }
                        ForEach(decks, id: \.self) { deck in
                            Button(deck.name) {
                                filteredMatches = filterMatchesByDeck(deck)
                                menuTitle = deck.name + " Results"
                                selectedDeck = deck
                            }
                        }
                    }.frame(width: max(geometry.size.width - 30, 0), height: 35)
                        .background(Color.secondary)
                    
                    HStack {
                        Text("You")
                            .frame(width: max(geometry.size.width / 2 - 20, 0), height: 35)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .background(.playerBlue)
                        
                        Text("Opponent")
                            .frame(width: max(geometry.size.width / 2 - 20, 0), height: 35)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .background(.playerPink)
                    }
                    
                    if menuTitle != "Filter by Deck" {
                        let percent = String(format: "%.2f", Deck.winRate(deck: selectedDeck!, context: modelContext))
                        Text("\(percent)% Win Rate")
                            .font(.caption)
                            .textCase(.uppercase)
                    }
                    
                    List {
                        ForEach(filteredMatches, id: \.self) { match in
                            MatchRowView(match: match)
                        }
                        .listRowBackground(Color.background)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.background)
                    .padding(.horizontal, -20)
                }
            }.foregroundStyle(.white)
        }
        .navigationDestination(isPresented: $navigateToCreateMatchView){
            AddMatchView()
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
                Text("Match History")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Allow user to save a match
                    navigateToCreateMatchView = true
                }) {
                    HStack {
                        Image(systemName: "plus") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            matches = Match.load(context: modelContext)
            filteredMatches = matches
            
            var myDecks: Set<Deck> = []
            for match in matches {
                myDecks.insert(match.userDeck)
            }
            decks = Array(myDecks).sorted { $0.name < $1.name }
        }
    }
    
    private func filterMatchesByDeck(_ deck: Deck?) -> [Match] {
        guard let deck else {
            return matches
        }
        return matches.filter { $0.userDeck == deck }
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", champions: [playerChampion], elements: [.fire, .crux])
    
    let opponentChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let opponentDeck = Deck(name: "Deck 1", champions: [opponentChampion, playerChampion], elements: [.fire, .crux, .water])
    
    let match = Match.init(didUserWin: true, userDeck: playerDeck, opponentDeck: opponentDeck)
    
    NavigationStack {
        DeckHistoryView(matches: [match, match, match, match, match, match, match, match, match, match])
    }
}
