//
//  Deck.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import Foundation
import SwiftData
import SwiftUI

enum Element: Codable, CaseIterable {
    case fire
    case wind
    case water
    case norm
    
    // Computed property for associated colors
    var color: Color {
        switch self {
        case .fire: return .red
        case .wind: return .green
        case .water: return .blue
        case .norm: return .gray
        }
    }
}

@Model
class Deck: Codable {
    var name: String
    var champion: Champion
    var element: Element
    var cards: [Card] // This won't get use for now. Long term I'll let people store what cards they have in their deck and import from SIlvie.
    var winRate: Double?
    
    init(name: String, champion: Champion, element: Element, cards: [Card] = [], winRate: Double = 0) {
        self.name = name
        self.champion = champion
        self.element = element
        self.cards = cards
        self.winRate = winRate
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case champion
        case element
        case cards
        case winRate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        champion = try container.decode(Champion.self, forKey: .champion)
        element = try container.decode(Element.self, forKey: .element)
        cards = try container.decode([Card].self, forKey: .cards)
        winRate = try container.decodeIfPresent(Double.self, forKey: .winRate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(champion, forKey: .champion)
        try container.encode(element, forKey: .element)
        try container.encode(cards, forKey: .cards)
        try container.encodeIfPresent(winRate, forKey: .winRate)
    }
}
