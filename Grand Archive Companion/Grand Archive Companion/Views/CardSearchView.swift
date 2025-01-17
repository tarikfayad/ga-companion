//
//  CardSearchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct CardSearchView: View {
    
    @State private var searchText: String = ""
    @State private var cards: [Card] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            List {
                if isLoading {
                    ProgressView("Searching for cards...")
                } else {
                    ForEach(cards, id: \.uuid) { card in
                        Text(card.name)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Card name")
            .onSubmit(of: .search){
                Task {
                    isLoading = true
                    do {
                        cards = try await performCardSearch(for: searchText)
                    } catch {
                        print("Failed to fetch cards: \(error)")
                    }
                    isLoading = false
                }
            }
            .overlay{
                if cards.isEmpty {
                    ContentUnavailableView("No Cards Found", systemImage: "magnifyingglass.circle", description: Text("Enter a card name to search\nor check the spelling of your search."))
                }
            }
        }
            
    }
}

#Preview {
    CardSearchView()
}
