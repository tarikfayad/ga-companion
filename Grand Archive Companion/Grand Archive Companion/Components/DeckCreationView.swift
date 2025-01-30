//
//  DeckCreationView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI

struct DeckCreationView: View {
    @State private var deckName: String = ""
    @State private var searchText = ""
    @State private var selectedChampions: Set<Champion> = []
    @State private var isShowingChampions: Bool = false
    @State private var elements: Set<Element> = []
    @State private var isShowingElements: Bool = false
    @State private var userDidWin: Bool = false
    @State var deckString: String = "Your Deck"
    
    @State var isUserDeck: Bool = true
    
    var body: some View {
        VStack {
            Text(deckString)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.top, 10)
            
            if isUserDeck {
                Menu("Select a Saved Deck") {
                    
                }
                .frame(width: 180, height: 25)
                .background(Color.secondary.opacity(0.2))
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
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
                .background(Color.secondary)
                .popover(isPresented: $isShowingChampions) {
                    VStack {
                        List(Champion.generateAllChampions(), id: \.self) { champion in
                            HStack {
                                Text(champion.name)
                                    .frame(maxWidth: .infinity)
                                Spacer()
                                if selectedChampions.contains(champion) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
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
                                if elements.contains(element) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                }
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
                    Text("Lost / Won")
                    Toggle("Lose : Win", isOn: $userDidWin)
                        .labelsHidden()
                        .background(userDidWin ? Color.green : Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }.padding(.horizontal, 5)
            }
        }
        .padding()
        .foregroundStyle(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
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
}

#Preview {
    DeckCreationView()
        .background(Color.gray.opacity(0.2))
}
