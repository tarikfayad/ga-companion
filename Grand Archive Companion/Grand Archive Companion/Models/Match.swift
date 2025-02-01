//
//  Match.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import Foundation
import SwiftData

@Model
class Match: Codable, Identifiable {
    var id: UUID
    var date: Date
    var didUserWin: Bool
    var userDeck: Deck
    var opponentDeck: Deck
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), didUserWin: Bool, userDeck: Deck, opponentDeck: Deck, notes: String? = nil) {
        self.id = id
        self.date = date
        self.didUserWin = didUserWin
        self.userDeck = userDeck
        self.opponentDeck = opponentDeck
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case didUserWin
        case userDeck
        case opponentDeck
        case notes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        didUserWin = try container.decode(Bool.self, forKey: .didUserWin)
        userDeck = try container.decode(Deck.self, forKey: .userDeck)
        opponentDeck = try container.decode(Deck.self, forKey: .opponentDeck)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(didUserWin, forKey: .didUserWin)
        try container.encode(userDeck, forKey: .userDeck)
        try container.encode(opponentDeck, forKey: .opponentDeck)
        try container.encodeIfPresent(notes, forKey: .notes)
    }
    
    static func save(matches: [Match], context: ModelContext) {
        matches.forEach {
            context.insert($0.userDeck)
            context.insert($0.opponentDeck)
            context.insert($0)
        }
        do {
            try context.save()
        } catch {
            print("Failed to save matches: \(error)")
        }
    }
    
    static func load(context: ModelContext) -> [Match] {
        let fetchDescriptor = FetchDescriptor<Match>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to load matches: \(error)")
            return []
        }
    }
}
