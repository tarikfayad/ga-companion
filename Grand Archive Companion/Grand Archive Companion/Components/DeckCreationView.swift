//
//  DeckCreationView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI

struct DeckCreationView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var deckName: String
    @Binding var selectedChampions: Set<Champion>
    @Binding var elements: Set<Element>
    @Binding var userDidWin: Bool
    
    @State private var isShowingChampions: Bool = false
    @State private var isShowingElements: Bool = false
    @State var deckString: String = "Your Deck"
    
    @State var isUserDeck: Bool = true
    @State var userDecks: [Deck] = []
    @State var opponentDecks: [Deck] = []
    
    @State private var savedDecks: [Deck] = []
    var onDeckSelect: (Deck) -> Void
    
    var body: some View {
        VStack {
            Text(deckString)
                .font(.system(size: 20, weight: .bold, design: .default))
            
            if savedDecks.count > 0 {
                Menu("Load a Saved Deck") {
                    ForEach(savedDecks, id: \.self) { deck in
                        Button {
                            selectDeck(deck)
                        }
                        label: {
                            Text(deck.name)
                        }
                    }
                }
                .frame(width: 180, height: 25)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        
                )
                .foregroundStyle(.black)
            }
            
            TextField("Enter a deck name...", text: $deckName)
                .preferredColorScheme(.dark)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.secondary)
                        .offset(y: 12)
                ) 
                .padding(.vertical, 5)
            
            HStack {
                Button {
                    isShowingChampions.toggle()
                } label: {
                    Text("Champions")
                    Image(systemName: "person.circle")
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
                .background(Color.secondary)
                .popover(isPresented: $isShowingChampions) {
                    VStack {
                        List(Champion.retrieveChampionsWithLineages(), id: \.self) { champion in
                            HStack {
                                Text(champion.name)
                                    .frame(maxWidth: .infinity)
                                Spacer()
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(.green)
                                    .opacity(selectedChampions.contains(champion) ? 1 : 0)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleChampionSelection(for: champion)
                            }
                        }
                    }
                    .background(Color.secondary)
                    .presentationDragIndicator(.visible)
                }
                
                Button {
                    isShowingElements.toggle()
                } label: {
                    Text("Deck Elements")
                    Image(systemName: "flame.fill")
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
                .background(Color.secondary)
                .popover(isPresented: $isShowingElements) {
                    VStack {
                        List(Element.allCases, id: \.self) { element in
                            HStack {
                                let capitalizedElement = element.rawValue.capitalized
                                Text(capitalizedElement)
                                    .frame(maxWidth: .infinity)
                                Spacer()
                                
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(.green)
                                    .opacity(elements.contains(element) ? 1 : 0)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleElementSelection(for: element)
                            }
                        }
                    }
                    .background(Color.secondary)
                    .presentationDragIndicator(.visible)
                }
            }
            
            if isUserDeck {
                HStack {
                    Text("Lost")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(userDidWin ? .gray : .white)
                        .padding(8)
                        .background(userDidWin ? Color.clear : Color.red)
                        .cornerRadius(8)
                        .onTapGesture {
                            userDidWin = false
                        }
                    
                    Text("Won")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(userDidWin ? .white : .gray)
                        .padding(8)
                        .background(userDidWin ? Color.green : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture {
                            userDidWin = true
                        }
                }
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .padding(.top, 5)
            }
        }
        .padding()
        .foregroundStyle(.white)
        .onAppear {
            savedDecks = isUserDeck ? Deck.loadUserDecks(context: modelContext) : Deck.loadOpponentDecks(context: modelContext)
        }
    }
    
    // Helper Functions
    private func toggleChampionSelection(for item: Champion) {
        if selectedChampions.contains(item) {
            selectedChampions.remove(item)
        } else {
            selectedChampions.insert(item)
        }
    }
    
    private func toggleElementSelection(for item: Element) {
        if elements.contains(item) {
            elements.remove(item)
        } else {
            elements.insert(item)
        }
    }
    
    private func selectDeck(_ deck: Deck) {
        deckName = deck.name
        selectedChampions = Set(deck.champions)
        elements = Set(deck.elements)
        onDeckSelect(deck)
    }
}

#Preview {
    @Previewable @State var deckName: String = ""
    @Previewable @State var selectedChampions: Set<Champion> = []
    @Previewable @State var elements: Set<Element> = []
    @Previewable @State var userDidWin: Bool = false
    
    DeckCreationView(deckName: $deckName, selectedChampions: $selectedChampions, elements: $elements, userDidWin: $userDidWin, deckString: "Your Deck", isUserDeck: true) {_ in}
        .background(Color.gray.opacity(0.2))
}
