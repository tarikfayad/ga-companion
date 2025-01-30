//
//  DeckHistoryView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import SwiftUI

struct DeckHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var matches: [Match] = []
    @State private var navigateToCreateMatchView = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.background.ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Menu("Filter by Deck") {
                        Button("Option 1") { print("Option 1 selected") }
                        Button("Option 2") { print("Option 2 selected") }
                        Button("Option 3") { print("Option 3 selected") }
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
                    List {
                        ForEach(matches, id: \.self) { match in
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
        }
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let playerDeck = Deck(name: "Deck 1", champion: playerChampion, elements: [.fire, .crux])
    
    let opponentChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    let opponentDeck = Deck(name: "Deck 1", champion: opponentChampion, elements: [.fire, .crux])
    
    let match = Match.init(didUserWin: true, userDeck: playerDeck, opponentDeck: opponentDeck)
    
    DeckHistoryView(matches: [match, match, match, match, match, match, match, match, match, match])
}
