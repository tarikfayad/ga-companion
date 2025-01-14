//
//  Grand_Archive_CompanionApp.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/14/25.
//

import SwiftUI
import SwiftData

@main
struct Grand_Archive_CompanionApp: App {
    @Environment(\.modelContext) private var modelContext
    
    init() {
        populateChampionData()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func populateChampionData() {
        let champions: [Champion] = [
            .init(name: "Aithne, Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Allen, Beast Beckoner", lineage: "", jobs: ["Tamer"], health: 22, level: 2),
            .init(name: "Arisanna, Astral Zenith", lineage:"Arisanna", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Arisanna, Herbalist Prodigy", lineage:"", jobs: ["Cleric"], health: 19, level: 1),
            .init(name: "Arisanna, Lucent Arbiter", lineage:"Arisanna", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Arisanna, Master Alchemist", lineage: "Arisanna", jobs: ["Cleric"], health: 22, level: 2),
            .init(name: "Brissa, Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Diana, Cursebreaker", lineage: "Diana", jobs: ["Ranger"], health: 25, level: 3),
            .init(name: "Diana, Deadly Duelist", lineage: "Diana", jobs: ["Ranger"], health: 22, level: 2),
            .init(name: "Diana, Duskstalker", lineage: "Diana", jobs: ["Ranger"], health: 25, level: 3),
            .init(name: "Diana, Keen Huntress", lineage: "", jobs: ["Ranger"], health: 19, level: 1),
            .init(name: "Fragmented Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Fragmented Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Fragmented Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Gwendolyn, Spirit of Wind", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Jin, Fate Defiant", lineage: "", jobs: ["Warrior"], health: 20, level: 1),
            .init(name: "Jin, Undying Resolve", lineage: "Jin", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Jin, Zealous Maverick", lineage: "Jin", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Kongming, Ascetic Vice", lineage: "Kongming", jobs: ["Mage"], health: 22, level: 2),
            .init(name: "Kongming, Fel Eidolon", lineage: "Kongming", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Kongming, Wayward Maven", lineage: "", jobs: ["Mage"], health: 19, level: 1),
            .init(name: "Lorraine, Blademaster", lineage: "Lorraine", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Lorraine, Spirit Ruler", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3),
            .init(name: "Lorraine, Wandering Warrior", lineage: "", jobs: ["Warrior"], health: 20, level: 1),
            .init(name: "Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Merlin, Kingslayer", lineage: "Merlin", jobs: ["Mage", "Warrior"], health: 28, level: 3),
            .init(name: "Merlin, Memory Thief", lineage: "", jobs: ["Mage"], health: 22, level: 2),
            .init(name: "Minthe, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Mordred, Flawless Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Morrigan, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Nameless Champion", lineage: "", jobs: ["Guardian", "Mage"], health: 20, level: 1),
            .init(name: "Nico, Rapture's Embrace", lineage: "", jobs: ["Guardian"], health: 20, level: 1),
            .init(name: "Nico, Whiplash Allure", lineage: "", jobs: ["Guardian"], health: 25, level: 2),
            .init(name: "Polkhawk, Boisterous Riot", lineage: "", jobs: ["Ranger"], health: 19, level: 1),
            .init(name: "Polkhawk, Bombastic Shot", lineage: "", jobs: ["Ranger"], health: 22, level: 2),
            .init(name: "Priscilla, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Prismatic Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Rai, Archmage", lineage: "Rai", jobs: ["Mage"], health: 22, level: 2),
            .init(name: "Rai, Mana Weaver", lineage: "Rai", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Rai, Spellcrafter", lineage: "", jobs: ["Mage"], health: 19, level: 1),
            .init(name: "Rai, Storm Seer", lineage: "Rai", jobs: ["Mage"], health: 25, level: 3),
            .init(name: "Sabrina, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Shira, Lost Spirit", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Silvie, Earth's Tune", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Loved by All", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Slime Sovereign", lineage: "Silvie", jobs: ["Tamer"], health: 25, level: 3),
            .init(name: "Silvie, Wilds Whisperer", lineage: "", jobs: ["Tamer"], health: 19, level: 1),
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
            .init(name: "Tonoris, Lone Mercenary", lineage: "", jobs: ["Guardian"], health: 20, level: 1),
            .init(name: "Tonoris, Might of Humanity", lineage: "Tonoris", jobs: ["Guardian"], health: 25, level: 2),
            .init(name: "Tristan, Grim Stalker", lineage: "", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Tristan, Hired Blade", lineage: "Tristan", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Tristan, Shadowdancer", lineage: "Tristan", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Tristan, Shadowreaver", lineage: "Tristan", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Tristan, Underhanded", lineage: "", jobs: ["Assassin"], health: 19, level: 1),
            .init(name: "Vanitas, Convergent Ruin", lineage: "Vanitas", jobs: ["Cleric"], health: 22, level: 2),
            .init(name: "Vanitas, Dominus Rex", lineage: "Vanitas", jobs: ["Cleric"], health: 25, level: 3),
            .init(name: "Vanitas, Obliviate Schemer", lineage: "", jobs: ["Cleric"], health: 19, level: 1),
            .init(name: "Vyra, Spirit of Fire", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Zander, Always Watching", lineage: "Zander", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Zander, Blinding Steel", lineage: "Zander", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Zander, Corhazi's Chosen", lineage: "Zander", jobs: ["Assassin"], health: 25, level: 3),
            .init(name: "Zander, Deft Executor", lineage: "Zander", jobs: ["Assassin"], health: 22, level: 2),
            .init(name: "Zander, Prepared Scout", lineage: "", jobs: ["Assassin"], health: 19, level: 1)
        ]
    }
}
