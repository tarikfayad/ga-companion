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
class Deck: Codable {
    var name: String
    var champions: [Champion]
    var elements: [Element]
    var cards: [Card] // This won't get use for now. Long term I'll let people store what cards they have in their deck and import from SIlvie.
    var winRate: Double?
    
    init(name: String, champions: [Champion], elements: [Element], cards: [Card] = [], winRate: Double = 0) {
        self.name = name
        self.champions = champions
        self.elements = elements
        self.cards = cards
        self.winRate = winRate
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case champions
        case elements
        case cards
        case winRate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        champions = try container.decode([Champion].self, forKey: .champions)
        elements = try container.decode([Element].self, forKey: .elements)
        cards = try container.decode([Card].self, forKey: .cards)
        winRate = try container.decodeIfPresent(Double.self, forKey: .winRate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(champions, forKey: .champions)
        try container.encode(elements, forKey: .elements)
        try container.encode(cards, forKey: .cards)
        try container.encodeIfPresent(winRate, forKey: .winRate)
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
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to load decks: \(error)")
            return []
        }
    }
}
