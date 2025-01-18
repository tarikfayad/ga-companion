//
//  Card.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/16/25.
//

import Foundation
import SwiftUI

struct Rule: Codable {
    let title: String
    let dateAdded: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case dateAdded = "date_added"
        case description
    }
}

struct Edition: Codable {
    let slug: String
    let rarity: Int
    
    var rarityDescription: String {
        switch rarity {
        case 1: return "Common"
        case 2: return "Uncommon"
        case 3: return "Rare"
        case 4: return "Super Rare"
        case 5: return "Ultra Rare"
        case 6: return "Promotional Rare"
        case 7: return "Collector Super Rare"
        case 8: return "Collector Ultra Rare"
        case 9: return "Collector Promo Rare"
        default: return "Unknown Rarity"
        }
    }
    
    var rarityColor: Color {
        switch rarity {
        case 1: return .gray
        case 2: return .green
        case 3: return .blue
        case 4: return .purple
        case 5: return .yellow
        case 6: return .pink
        case 7: return .white
        case 8: return .white
        case 9: return .white
        default: return .gray
        }
    }
}

struct Legality: Codable {
    struct Standard: Codable {
        let limit: Int
    }

    let STANDARD: Standard?
}

struct Card: Codable {
    let uuid: String
    let types: [String]
    let classes: [String]
    let subtypes: [String]
    let element: String
    let name: String
    let slug: String
    let effect: String?
    let rules: [Rule]?
    let flavorText: String?
    let memoryCost: Int?
    let reserveCost: Int?
    let level: Int?
    let power: Int?
    let life: Int?
    let durability: Int?
    let speed: Bool?
    let imageURL: URL?
    let resultEditions: [Edition]
    let legality: Legality?
    
    var isBanned: Bool {
        legality?.STANDARD?.limit == 0
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case types
        case classes
        case subtypes
        case element
        case name
        case slug
        case effect
        case rules = "rule" // Maps JSON "rule" to Swift "rules"
        case flavorText = "flavor"
        case memoryCost = "cost_memory"
        case reserveCost = "cost_reserve"
        case level
        case power
        case life
        case durability
        case speed
        case resultEditions = "result_editions"
        case legality
    }
    
    // Custom initializer to build the imageURL
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all normal fields
        uuid = try container.decode(String.self, forKey: .uuid)
        types = try container.decode([String].self, forKey: .types)
        classes = try container.decode([String].self, forKey: .classes)
        subtypes = try container.decode([String].self, forKey: .subtypes)
        element = try container.decode(String.self, forKey: .element)
        name = try container.decode(String.self, forKey: .name)
        slug = try container.decode(String.self, forKey: .slug)
        effect = try container.decodeIfPresent(String.self, forKey: .effect)
        rules = try container.decodeIfPresent([Rule].self, forKey: .rules)
        flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
        memoryCost = try container.decodeIfPresent(Int.self, forKey: .memoryCost)
        reserveCost = try container.decodeIfPresent(Int.self, forKey: .reserveCost)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        power = try container.decodeIfPresent(Int.self, forKey: .power)
        life = try container.decodeIfPresent(Int.self, forKey: .life)
        durability = try container.decodeIfPresent(Int.self, forKey: .durability)
        speed = try container.decodeIfPresent(Bool.self, forKey: .speed)
        resultEditions = try container.decode([Edition].self, forKey: .resultEditions)
        legality = try container.decodeIfPresent(Legality.self, forKey: .legality)
        
        if let firstEdition = resultEditions.first {
            self.imageURL = URL(string: "https://ga-index-public.s3.us-west-2.amazonaws.com/cards/\(firstEdition.slug).jpg")
        } else {
            self.imageURL = nil
        }
    }
    
}
