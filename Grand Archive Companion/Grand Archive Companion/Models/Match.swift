//
//  Match.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import Foundation
import SwiftData

@Model
class Match: Identifiable {
    var id: UUID
    var date: Date
    var didUserWin: Bool
    var userDeck: Deck
    var opponentDeck: Deck
    var notes: String?
    @Relationship(deleteRule: .cascade) var playerOneDamageHistory: [Damage]
    @Relationship(deleteRule: .cascade) var playerTwoDamageHistory: [Damage]
    
    init(id: UUID = UUID(), date: Date = Date(), didUserWin: Bool, userDeck: Deck, opponentDeck: Deck, notes: String? = nil, playerOneDamageHistory: [Damage] = [], playerTwoDamageHistory: [Damage] = []) {
        self.id = id
        self.date = date
        self.didUserWin = didUserWin
        self.userDeck = userDeck
        self.opponentDeck = opponentDeck
        self.notes = notes
        self.playerOneDamageHistory = playerOneDamageHistory
        self.playerTwoDamageHistory = playerTwoDamageHistory
    }
    
    static func save(matches: [Match], context: ModelContext) {
        matches.forEach { context.insert($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save matches: \(error)")
        }
    }
    
    static func load(context: ModelContext) -> [Match] {
        let fetchDescriptor = FetchDescriptor<Match>()
        do {
            let matches = try context.fetch(fetchDescriptor)
            print("Successfully loaded \(matches.count) matches")
            return matches
        } catch {
            print("Failed to load matches: \(error)")
            return []
        }
    }
    
    static func loadMatchesForDeck(_ deck: Deck, context: ModelContext) -> [Match] {
        let deckID = deck.id // cannot reference a model object inside of a predicate so doing so here
        let fetchDescriptor = FetchDescriptor<Match>(
            predicate: #Predicate { $0.userDeck.id == deckID || $0.opponentDeck.id == deckID }
        )
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to load matches for deck: \(error)")
            return []
        }
    }
}
