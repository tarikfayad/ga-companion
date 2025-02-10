//
//  Deck.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Deck {
    var id: UUID = UUID()
    var name: String
    var isUserDeck: Bool = false
    var champions: [Champion]
    var elements: [Element]
    @Relationship(deleteRule: .cascade) var materialDeck: [Card] // This won't get use for now. Long term I'll let people store what cards they have in their deck and import from SIlvie.
    @Relationship(deleteRule: .cascade) var mainDeck: [Card]
    @Relationship(deleteRule: .cascade) var sideDeck: [Card]
    
    init(id: UUID = UUID(), name: String, isUserDeck: Bool = false, champions: [Champion], elements: [Element], materialDeck: [Card] = [], mainDeck: [Card] = [], sideDeck: [Card] = []) {
        self.id = id
        self.name = name
        self.isUserDeck = isUserDeck
        self.champions = champions
        self.elements = elements
        self.materialDeck = materialDeck
        self.mainDeck = mainDeck
        self.sideDeck = sideDeck
    }
    
    static func save(decks: [Deck], context: ModelContext) {
        decks.forEach { context.insert($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save decks: \(error)")
        }
    }
    
    // Function to load all deck objects
    static func load(context: ModelContext) -> [Deck] {
        let fetchDescriptor = FetchDescriptor<Deck>()
        do {
            let decks = try context.fetch(fetchDescriptor)
            print("Successfully loaded \(decks.count) decks")
            return decks
        } catch {
            print("Failed to load decks: \(error)")
            return []
        }
    }
    
    static func loadUserDecks(context: ModelContext) -> [Deck] {
        let fetchDescriptor = FetchDescriptor<Deck>(
            predicate: #Predicate { $0.isUserDeck }
        )
        do {
            let decks = try context.fetch(fetchDescriptor)
            print("Successfully loaded \(decks.count) decks")
            return decks
        } catch {
            print("Failed to load decks: \(error)")
            return []
        }
    }
    
    static func loadOpponentDecks(context: ModelContext) -> [Deck] {
        let fetchDescriptor = FetchDescriptor<Deck>(
            predicate: #Predicate { $0.isUserDeck == false }
        )
        do {
            let decks = try context.fetch(fetchDescriptor)
            print("Successfully loaded \(decks.count) decks")
            return decks
        } catch {
            print("Failed to load decks: \(error)")
            return []
        }
    }
    
    static func delete(deck: Deck, context: ModelContext) {
        let deckID = deck.id
        
        let fetchDescriptor = FetchDescriptor<Deck>(
            predicate: #Predicate { $0.id == deckID }
        )
        do {
            let decks = try context.fetch(fetchDescriptor)
            for deck in decks {
                context.delete(deck)
            }
            try context.save()
            print("Deck deleted successfully.")
        } catch let error as NSError {
            print("Failed to save context: \(error.localizedDescription)")
            print("Error details: \(error.userInfo)")
        }
    }
    
    static func winRate(deck: Deck, context: ModelContext) -> Double {
        let deckID = deck.id // cannot reference a model object inside of a predicate so doing so here
        let fetchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate { $0.userDeck.id == deckID }
        )
        do {
            let matches = try context.fetch(fetchDescriptor)
            var wins: Int = 0
            for match in matches {
                if match.didUserWin {
                    wins += 1
                }
            }
            return Double(wins) / Double(matches.count) * 100
        } catch {
            print("Failed to load win rate: \(error)")
            return 0
        }
    }
    
    static func winRate(deck: Deck, champion: Champion, context: ModelContext) -> Double {
        let deckID = deck.id // cannot reference a model object inside of a predicate so doing so here
        let fetchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate { $0.userDeck.id == deckID }
        )
        do {
            let matches = try context.fetch(fetchDescriptor)
            var wins: Int = 0
            var totalMatches: Int = 0
            for match in matches {
                if match.opponentDeck.champions.contains(champion) {
                    totalMatches += 1
                    if match.didUserWin {
                        wins += 1
                    }
                }
            }
            return Double(wins) / Double(totalMatches) * 100
        } catch {
            print("Failed to load win rate vs \(champion.name): \(error)")
            return 0
        }
    }
    
    // Retrieve all the matchups that a deck has played.
    static func getAllPlayedChampions(deck: Deck, context: ModelContext) -> [Champion] {
        let deckID = deck.id
        let fetchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate { $0.userDeck.id == deckID }
        )
        do {
            let matches = try context.fetch(fetchDescriptor)
            var champions: [Champion] = []
            for match in matches {
                champions.append(contentsOf: match.opponentDeck.champions)
            }
            return Champion.filterChampionsByLineage(champions)
        } catch {
            print("Failed to load list of champions played: \(error)")
            return []
        }
    }
    
    static func isLegal(deck: Deck) -> Bool {
        let cards = Set(deck.materialDeck + deck.sideDeck + deck.mainDeck)
        for card in cards {
            if card.isBanned {
                return false
            }
        }
        return true
    }
}
