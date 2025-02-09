//
//  DeckListView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI

struct DeckHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext

    @State private var debouncedSearch: (() -> Void)?
    @State private var searchText: String = ""
    @State private var decks: [Deck] = []
    @State private var filteredDecks: [Deck] = []
    @State private var isLoading: Bool = false
    @State private var navigateToDeckView = false
    @State private var selectedDeck: Deck?

    var body: some View {
        List {
            ForEach(filteredDecks, id: \.self) { deck in
                if isLoading {
                    ProgressView("Searching for decks...")
                } else {
                    DeckRowView(deck: deck)
                        .listRowBackground(Color.background)
                        .onTapGesture {
                            selectedDeck = deck
                            navigateToDeckView = true
                        }
                }
            }
            .onDelete(perform: deleteDeck)
        }
        .applyBackground()
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Filter by deck name or champion...")
        .disableAutocorrection(true)
        .onSubmit(of: .search) {
             filterDecks()
        }
        .onChange(of: searchText) { newValue in
            // MARK: Deprecated but much easier to use than alternatives. Will change when needed.
            searchText = newValue
            debouncedSearch?()
        }
        .overlay {
            if decks.isEmpty {
                ContentUnavailableView("Decks", systemImage: "magnifyingglass.circle", description: Text("You haven't saved any decks yet."))
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
                 filterDecks()
            }
            
            decks = Deck.loadUserDecks(context: modelContext)
            filteredDecks = decks
        }
        .navigationDestination(isPresented: $navigateToDeckView) {
            if let selectedDeck = selectedDeck {
                DeckDetailView(deck: selectedDeck)
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
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
    
    func filterDecks() {
        Task {
            isLoading = true
            filteredDecks = decks.filter { deck in
                deck.name.contains(searchText) || deck.champions.contains(where: { $0.name.contains(searchText) })
            }
            if searchText == "" { filteredDecks = decks }
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
    
    private func deleteDeck(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let deck = filteredDecks[index]
        filteredDecks.remove(atOffsets: offsets)
        decks.removeAll(where: { $0.id == deck.id })
        Deck.delete(deck: deck, context: modelContext)
    }
}

#Preview {
    DeckHistoryView()
}
