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
    
    var body: some View {
        
        List {
            ForEach(cards, id: \.uuid) { card in
                Text(card.name)
            }
        }.onAppear {
            Task {
                do {
                    cards = try await performCardSearch(for: "lorraine")
                } catch {
                    print("Failed to fetch cards: \(error)")
                }
            }
        }
            
    }
}

#Preview {
    CardSearchView()
}
