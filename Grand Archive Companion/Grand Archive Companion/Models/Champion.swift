//
//  Champion.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/14/25.
//

import Foundation
import SwiftData

@Model
class Champion: Codable, Equatable {
    var name: String
    var lineage: String
    var jobs: [String] // Called class in game but I can't use class as a variable name
    var health: Int
    var level: Int
    
    init(name: String, lineage: String, jobs: [String], health: Int, level: Int) {
        self.name = name
        self.lineage = lineage
        self.jobs = jobs
        self.health = health
        self.level = level
    }
    
    func imageName() -> String {
        return "\(lineage.lowercased())"
    }
    
    static func generateAllChampions() -> [Champion] {
        let champions: [Champion] = [
            .init(name: "Aithne, Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Allen, Beast Beckoner", lineage: "Allen", jobs: ["Tamer"], health: 22, level: 2), // Doesn't have a lineage on the actual card
            .init(name: "Arisanna, Astral Zenith", lineage:"Arisanna", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Arisanna, Herbalist Prodigy", lineage:"Arianna", jobs: ["Cleric"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Arisanna, Lucent Arbiter", lineage:"Arisanna", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Arisanna, Master Alchemist", lineage: "Arisanna", jobs: ["Cleric"], health: 22, level: 2),
            .init(name: "Brissa, Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Diana, Cursebreaker", lineage: "Diana", jobs: ["Ranger"], health: 25, level: 3),
            .init(name: "Diana, Deadly Duelist", lineage: "Diana", jobs: ["Ranger"], health: 22, level: 2),
            .init(name: "Diana, Duskstalker", lineage: "Diana", jobs: ["Ranger"], health: 25, level: 3),
            .init(name: "Diana, Keen Huntress", lineage: "Diana", jobs: ["Ranger"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Fragmented Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Fragmented Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Fragmented Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Gwendolyn, Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Jin, Fate Defiant", lineage: "Jin", jobs: ["Warrior"], health: 20, level: 1), // Doesn't have a lineage on the
            .init(name: "Jin, Undying Resolve", lineage: "Jin", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Jin, Zealous Maverick", lineage: "Jin", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Kongming, Ascetic Vice", lineage: "Kongming", jobs: ["Mage"], health: 22, level: 2),
            .init(name: "Kongming, Fel Eidolon", lineage: "Kongming", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Kongming, Wayward Maven", lineage: "Kongming", jobs: ["Mage"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Lorraine, Blademaster", lineage: "Lorraine", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Lorraine, Spirit Ruler", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Lorraine, Wandering Warrior", lineage: "Lorraine", jobs: ["Warrior"], health: 20, level: 1), // Doesn't have a lineage on the
            .init(name: "Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Merlin, Kingslayer", lineage: "Merlin", jobs: ["Mage", "Warrior"], health: 28, level: 3),
            .init(name: "Merlin, Memory Thief", lineage: "Merlin", jobs: ["Mage"], health: 22, level: 2), // Doesn't have a lineage on the
            .init(name: "Minthe, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Mordred, Flawless Blade", lineage: "Mordred", jobs: ["Warrior"], health: 24, level: 2), // Doesn't have a lineage on the
            .init(name: "Morrigan, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Nameless Champion", lineage: "", jobs: ["Guardian", "Mage"], health: 20, level: 1),
            .init(name: "Nico, Rapture's Embrace", lineage: "Nico", jobs: ["Guardian"], health: 20, level: 1), // Doesn't have a lineage on the
            .init(name: "Nico, Whiplash Allure", lineage: "Nico", jobs: ["Guardian"], health: 25, level: 2), // Doesn't have a lineage on the
            .init(name: "Polkhawk, Boisterous Riot", lineage: "Polkhawk", jobs: ["Ranger"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Polkhawk, Bombastic Shot", lineage: "Polkhawk", jobs: ["Ranger"], health: 22, level: 2), // Doesn't have a lineage on the
            .init(name: "Priscilla, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Prismatic Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Rai, Archmage", lineage: "Rai", jobs: ["Mage"], health: 22, level: 2),
            .init(name: "Rai, Mana Weaver", lineage: "Rai", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Rai, Spellcrafter", lineage: "Rai", jobs: ["Mage"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Rai, Storm Seer", lineage: "Rai", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Sabrina, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Shira, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Silvie, Earth's Tune", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Loved by All", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Slime Sovereign", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Wilds Whisperer", lineage: "Silvie", jobs: ["Tamer"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Silvie, With the Pack", lineage: "Silvie", jobs: ["Tamer"], health: 22, level: 2),
            .init(name: "Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Serene Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Serene Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Serene Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Slime", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Tonoris, Creation's Will", lineage: "Tonoris", jobs: ["Guardian"], health: 30, level: 3),
            .init(name: "Tonoris, Genesis Aegis", lineage: "Tonoris", jobs: ["Guardian"], health: 30, level: 3),
            .init(name: "Tonoris, Lone Mercenary", lineage: "Tonoris", jobs: ["Guardian"], health: 20, level: 1), // Doesn't have a lineage on the
            .init(name: "Tonoris, Might of Humanity", lineage: "Tonoris", jobs: ["Guardian"], health: 25, level: 2),
            .init(name: "Tristan, Grim Stalker", lineage: "Tristan", jobs: ["Assassin"], health: 22, level: 2), // Doesn't have a lineage on the
            .init(name: "Tristan, Hired Blade", lineage: "Tristan", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Tristan, Shadowdancer", lineage: "Tristan", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Tristan, Shadowreaver", lineage: "Tristan", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Tristan, Underhanded", lineage: "Tristan", jobs: ["Assassin"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Vanitas, Convergent Ruin", lineage: "Vanitas", jobs: ["Cleric"], health: 22, level: 2),
            .init(name: "Vanitas, Dominus Rex", lineage: "Vanitas", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Vanitas, Obliviate Schemer", lineage: "Vanitas", jobs: ["Cleric"], health: 19, level: 1), // Doesn't have a lineage on the
            .init(name: "Vyra, Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Zander, Always Watching", lineage: "Zander", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Zander, Blinding Steel", lineage: "Zander", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Zander, Corhazi's Chosen", lineage: "Zander", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Zander, Deft Executor", lineage: "Zander", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Zander, Prepared Scout", lineage: "Zander", jobs: ["Assassin"], health: 19, level: 1) // Doesn't have a lineage on the
        ]
        return champions
    }
    
    // MARK: - Encodable
    
    enum CodingKeys: String, CodingKey {
        case name
        case lineage
        case jobs
        case health
        case level
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        lineage = try container.decode(String.self, forKey: .lineage)
        jobs = try container.decode([String].self, forKey: .jobs)
        health = try container.decode(Int.self, forKey: .health)
        level = try container.decode(Int.self, forKey: .level)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(lineage, forKey: .lineage)
        try container.encode(jobs, forKey: .jobs)
        try container.encode(health, forKey: .health)
        try container.encode(level, forKey: .level)
    }
}

extension Champion: Hashable {
    static func == (lhs: Champion, rhs: Champion) -> Bool {
        return lhs.name == rhs.name // Compare by unique name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name) // Use name for hashing
    }
}
