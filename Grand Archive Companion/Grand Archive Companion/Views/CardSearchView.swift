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
    
    init() {
        // Making the background of the search bar white so that it doesn't get lost in the dark background.
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            List(cards, id: \.uuid) { card in
                if isLoading {
                    ProgressView("Searching for cards...")
                } else {
                    CardRowView(card: card)
                        .listRowBackground(Color.background)
                        .onTapGesture {
                            print(card.name)
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Enter a card name...")
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
                    ContentUnavailableView("No Cards to Display", systemImage: "magnifyingglass.circle", description: Text("Enter a card name to search\nor check the spelling of your search."))
                        .foregroundStyle(.white)
                }
            }
        }.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .background
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
            
    }
}

#Preview {
    CardSearchView()
}
