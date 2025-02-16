//
//  DeckListView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

enum DeckSection {
    case material, main, side
}

struct DeckListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var deck: Deck
    @State private var deckName: String = ""
    @State private var creatingNewDeck: Bool = false
    @State private var selectedDeckSection: DeckSection? = nil
    @State private var showCardSearch: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                
                TextField("Enter a deck name...", text: $deckName)
                    .preferredColorScheme(.dark)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color.secondary)
                            .offset(y: 12)
                    )
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                
                Text("MATERIAL DECK")
                    .font(.caption)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(deck.materialDeck, id: \.uuid) { card in
                        WebImage(url: card.imageURL)
                            .resizable()
                            .frame(width: 100, height: 150)
                    }
                    
                    if deck.materialDeck.count < 12 {
                        ZStack {
                            Image("card_back")
                                .resizable()
                                .frame(width: 100, height: 150)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.8))
                        }.onTapGesture {
                            selectedDeckSection = .material
                            showCardSearch = true
                        }
                    }
                }
                
                Text("MAIN DECK")
                    .font(.caption)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(deck.mainDeck, id: \.uuid) { card in
                        WebImage(url: card.imageURL)
                            .resizable()
                            .frame(width: 100, height: 150)
                    }
                    
                    if deck.mainDeck.count < 60 {
                        ZStack {
                            Image("card_back")
                                .resizable()
                                .frame(width: 100, height: 150)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.8))
                        }.onTapGesture {
                            selectedDeckSection = .main
                            showCardSearch = true
                        }
                    }
                }
                
                Text("SIDEBOARD")
                    .font(.caption)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(deck.sideDeck, id: \.uuid) { card in
                        WebImage(url: card.imageURL)
                            .resizable()
                            .frame(width: 100, height: 150)
                    }
                    
                    if Deck.sideDeckPoints(deck: deck) < 15 {
                        ZStack {
                            Image("card_back")
                                .resizable()
                                .frame(width: 100, height: 150)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white.opacity(0.8))
                        }.onTapGesture {
                            selectedDeckSection = .side
                            showCardSearch = true
                        }
                    }
                }
            }
        }
        .applyBackground()
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            deckName = deck.name
            if deckName == "" { creatingNewDeck = true }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
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
                Text(deckName == "" ? "Create Deck" : "Edit Deck")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
//                    presentationMode.wrappedValue.dismiss() // Go back
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
        }
        .navigationDestination(isPresented: $showCardSearch) {
            CardSearchView(isComingFromDeckCreation: true)
        }
    }
}

#Preview {
    NavigationStack {
        DeckListView(deck: Deck.init())
    }
}
