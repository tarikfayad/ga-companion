//
//  Card.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/16/25.
//

import Foundation
import SwiftUI
import SwiftData

struct Rule: Codable, Equatable {
    let title: String
    let dateAdded: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case dateAdded = "date_added"
        case description
    }
}

struct Edition: Codable, Equatable {
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

struct Legality: Codable, Equatable {
    struct Standard: Codable, Equatable {
        let limit: Int
    }

    let STANDARD: Standard?
}

struct CardResponse: Codable, Equatable {
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
        rules = try container.decodeIfPresent([Rule].self, forKey: .rules)
        flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)?.replacingOccurrences(of: "\n", with: "\n\n")
        memoryCost = try container.decodeIfPresent(Int.self, forKey: .memoryCost)
        reserveCost = try container.decodeIfPresent(Int.self, forKey: .reserveCost)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        power = try container.decodeIfPresent(Int.self, forKey: .power)
        life = try container.decodeIfPresent(Int.self, forKey: .life)
        durability = try container.decodeIfPresent(Int.self, forKey: .durability)
        speed = try container.decodeIfPresent(Bool.self, forKey: .speed)
        resultEditions = try container.decode([Edition].self, forKey: .resultEditions)
        legality = try container.decodeIfPresent(Legality.self, forKey: .legality)
        
        if let rawEffect = try container.decodeIfPresent(String.self, forKey: .effect) {
            let transformedEffect = rawEffect
                .replacingOccurrences(of: "\n", with: "\n\n")
            
            // Updated regex pattern to handle all <span> tags
            let pattern = "<\\s*span[^>]*>(.*?)<\\s*/\\s*span\\s*>"

            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators, .caseInsensitive])
                var result = transformedEffect
                var previousResult: String

                repeat {
                    previousResult = result
                    let range = NSRange(result.startIndex..<result.endIndex, in: result)
                    result = regex.stringByReplacingMatches(in: result, options: [], range: range, withTemplate: "$1")
                } while result != previousResult

                effect = result
            } catch {
                print("Regex error: \(error)")
                effect = transformedEffect
            }
        } else {
            effect = nil
        }
        
        if let firstEdition = resultEditions.first {
            self.imageURL = URL(string: "https://ga-index-public.s3.us-west-2.amazonaws.com/cards/\(firstEdition.slug).jpg")
        } else {
            self.imageURL = nil
        }
    }
    
    func removeSpanTags(input: String) -> String {
        let pattern = "<span[^>]*>(.*?)<\\/span>"

        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let range = NSRange(input.startIndex..<input.endIndex, in: input)
            let output = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: "$1")
            return output
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            return ""
        }
    }
    
}

@Model
class Card {
    @Attribute(.unique) var uuid: UUID
    var types: [String]
    var classes: [String]
    var subtypes: [String]
    var element: String
    var name: String
    var slug: String
    var effect: String?
    var rules: [Rule]?
    var flavorText: String?
    var memoryCost: Int?
    var reserveCost: Int?
    var level: Int?
    var power: Int?
    var life: Int?
    var durability: Int?
    var speed: Bool?
    var imageURL: URL?
    var resultEditions: [Edition]
    var legality: Legality?
    
    var isBanned: Bool {
        legality?.STANDARD?.limit == 0
    }
    
    init(uuid: UUID, types: [String], classes: [String], subtypes: [String], element: String, name: String, slug: String, effect: String? = nil, rules: [Rule]? = nil, flavorText: String? = nil, memoryCost: Int? = nil, reserveCost: Int? = nil, level: Int? = nil, power: Int? = nil, life: Int? = nil, durability: Int? = nil, speed: Bool? = nil, imageURL: URL? = nil, resultEditions: [Edition], legality: Legality? = nil) {
        self.uuid = uuid
        self.types = types
        self.classes = classes
        self.subtypes = subtypes
        self.element = element
        self.name = name
        self.slug = slug
        self.effect = effect
        self.rules = rules
        self.flavorText = flavorText
        self.memoryCost = memoryCost
        self.reserveCost = reserveCost
        self.level = level
        self.power = power
        self.life = life
        self.durability = durability
        self.speed = speed
        self.imageURL = imageURL
        self.resultEditions = resultEditions
        self.legality = legality
    }
    
    static func createCardFromResponse(response: CardResponse) -> Card {
        return Card(
            uuid: UUID(),
            types: response.types,
            classes: response.classes,
            subtypes: response.subtypes,
            element: response.element,
            name: response.name,
            slug: response.slug,
            effect: response.effect,
            rules: response.rules,
            flavorText: response.flavorText,
            memoryCost: response.memoryCost,
            reserveCost: response.reserveCost,
            level: response.level,
            power: response.power,
            life: response.life,
            durability: response.durability,
            speed: response.speed,
            imageURL: response.imageURL,
            resultEditions: response.resultEditions,
            legality: response.legality
        )
    }
        
    
    static func save(cards: [Card], context: ModelContext) {
        cards.forEach { context.insert($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save cards: \(error)")
        }
    }
}
