//
//  Card.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/16/25.
//

import Foundation

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
        
        if let firstEdition = resultEditions.first {
            self.imageURL = URL(string: "https://ga-index-public.s3.us-west-2.amazonaws.com/cards/\(firstEdition.slug).jpg")
        } else {
            self.imageURL = nil
        }
    }
    
}
