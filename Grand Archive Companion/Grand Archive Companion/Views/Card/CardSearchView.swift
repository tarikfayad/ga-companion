//
//  CardSearchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct CardSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var debouncedSearch: (() -> Void)?
    
    @State private var searchText: String = ""
    @State private var cards: [Card] = []
    @State private var isLoading: Bool = false
    
    @State private var navigateToCardView = false
    @State private var selectedCard: Card?
    
    var body: some View {
        
        List(cards, id: \.uuid) { card in
            if isLoading {
                ProgressView("Searching for cards...")
            } else {
                CardRowView(card: card)
                    .listRowBackground(Color.background)
                    .onTapGesture {
                        selectedCard = card
                        navigateToCardView = true
                    }
            }
        }
        .applyBackground()
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Enter a card name...")
        .disableAutocorrection(true)
        .onSubmit(of: .search){
            searchCards()
        }
        .onChange(of: searchText) { newValue in
            // MARK: Deoreciated but much easier to use than alternatives. Will change when needed.
            searchText = newValue
            debouncedSearch?()
        }
        .overlay{
            if cards.isEmpty {
                ContentUnavailableView("Card Search", systemImage: "magnifyingglass.circle", description: Text("Enter a card name to search\nor check the spelling of your search."))
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .background
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            if colorScheme != .dark {
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
            }
            
            debouncedSearch = debounce(delay: 0.5) {
                searchCards()
            }
        }
        .navigationDestination(isPresented: $navigateToCardView) {
            if let selectedCard = selectedCard {
                CardDetailView(card: selectedCard)
            }
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
        }
    }
    
    func searchCards() {
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
    
    func debounce(delay: TimeInterval, action: @escaping () -> Void) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let queue = DispatchQueue.main

        return {
            let now = DispatchTime.now()
            let when = DispatchTime.now() + delay
            lastFireTime = now

            queue.asyncAfter(deadline: when) {
                if lastFireTime == now {
                    action()
                }
            }
        }
    }
}

#Preview {
    CardSearchView()
}
