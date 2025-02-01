//
//  AddMatchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI

struct AddMatchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State private var matchNotes: String = "Enter deck notes here..."
    
    // User deck variables
    @State private var userDeckName: String = ""
    @State private var userSelectedChampions: Set<Champion> = []
    @State private var userSelectedElements: Set<Element> = []
    @State private var userDidWin: Bool = false
    
    // Opponent deck variables
    @State private var opponentDeckName: String = ""
    @State private var opponentSelectedChampions: Set<Champion> = []
    @State private var opponentSelectedElements: Set<Element> = []
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack {
                DeckCreationView(deckName: $userDeckName, selectedChampions: $userSelectedChampions, elements: $userSelectedElements, userDidWin: $userDidWin, deckString: "Your Deck", isUserDeck: true)
                    .padding(.horizontal, 5)
                
                Text("VS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                
                DeckCreationView(deckName: $opponentDeckName, selectedChampions: $opponentSelectedChampions, elements: $opponentSelectedElements, userDidWin: .constant(false), deckString: "Opponent's Deck", isUserDeck: false)
                    .padding(.horizontal, 5)
                
                TextEditor(text: $matchNotes)
                    .frame(width: 350, height: 150)
                    .background(Color.secondary.opacity(0.1))
                
                Button {
                    saveMatch()
                } label: {
                    Text("Save Match")
                        .frame(width:270, height:27)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.playerBlue)
            }
        }
        .foregroundStyle(.white)
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
                Text("Add a Match")
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
        }
    }
    
    func saveMatch() {
        // Save match logic
    }
}

#Preview {
    NavigationStack {
        AddMatchView()
    }
}
