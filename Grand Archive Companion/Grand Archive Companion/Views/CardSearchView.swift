//
//  CardSearchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct CardSearchView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                Task {
                    do {
                        let cards = try await performCardSearch(for: "lorraine")
                        for card in cards {
                            print(card.name)
                        }
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
