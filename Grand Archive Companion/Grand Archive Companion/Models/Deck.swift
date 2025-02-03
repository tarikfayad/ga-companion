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
    var cards: [Card] // This won't get use for now. Long term I'll let people store what cards they have in their deck and import from SIlvie.
    
    init(id: UUID = UUID(), name: String, isUserDeck: Bool = false, champions: [Champion], elements: [Element], cards: [Card] = []) {
        self.id = id
        self.name = name
        self.isUserDeck = isUserDeck
        self.champions = champions
        self.elements = elements
        self.cards = cards
    }
    
    static func save(decks: [Deck], context: ModelContext) {
        decks.forEach { context.insert($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save decks: \(error)")
        }
    }
    
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
}
