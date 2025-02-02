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
    var champions: [Champion]
    var elements: [Element]
    var cards: [Card] // This won't get use for now. Long term I'll let people store what cards they have in their deck and import from SIlvie.
    var winRate: Double?
    
    init(id: UUID = UUID(), name: String, champions: [Champion], elements: [Element], cards: [Card] = [], winRate: Double = 0) {
        self.id = id
        self.name = name
        self.champions = champions
        self.elements = elements
        self.cards = cards
        self.winRate = winRate
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
}
