//
//  AddMatchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI
import SwiftData

struct AddMatchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSaveError: Bool = false
    
    @State private var matchNotes: String = "Enter deck notes here..."
    @FocusState private var isFocused: Bool
    
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
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .padding(.horizontal, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                
                Text("VS")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                
                DeckCreationView(deckName: $opponentDeckName, selectedChampions: $opponentSelectedChampions, elements: $opponentSelectedElements, userDidWin: .constant(false), deckString: "Opponent's Deck", isUserDeck: false)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.bottom, 20)
                
                Text("NOTES")
                    .font(.system(size: 12))
                    
                TextEditor(text: $matchNotes)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 150)
                    .scrollContentBackground(.hidden)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .focused($isFocused)
                    .onChange(of: isFocused) { focused in
                        if focused && matchNotes == "Enter deck notes here..." {
                            matchNotes = ""
                        }
                    }
                
                Button {
                    saveMatch()
                } label: {
                    Text("Save Match")
                        .frame(width:UIScreen.main.bounds.width - 50, height:27)
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
        .alert("Error!", isPresented: $showSaveError) {
            Button("OK") {
                showSaveError = false
            }
        } message: {
            Text("Please fill in all the fields (except notes) and try again.")
        }
    }
    
    func saveMatch() {
        if (userDeckName != "" && userSelectedChampions.count > 0 && userSelectedElements.count > 0 && opponentDeckName != "" && opponentSelectedChampions.count > 0 && opponentSelectedElements.count > 0) {
            
            // Create user and opponent decks
            let userDeck = Deck(name: userDeckName, champions: Array(userSelectedChampions), elements: Array(userSelectedElements))
            let opponentDeck = Deck(name: opponentDeckName, champions: Array(opponentSelectedChampions), elements: Array(opponentSelectedElements))
            
            // Create the match
            let newMatch = Match(didUserWin: userDidWin, userDeck: userDeck, opponentDeck: opponentDeck, notes: matchNotes)
            
            Deck.save(decks: [userDeck, opponentDeck], context: modelContext) // Inserting them into the context and saving them before saving the match. Could be done in the Match save function as well.
            Match.save(matches: [newMatch], context: modelContext)
            dismiss()
        } else {
            showSaveError.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        AddMatchView()
    }
}
