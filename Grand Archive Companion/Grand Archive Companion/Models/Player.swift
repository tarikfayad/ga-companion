//
//  Player.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/20/25.
//
import Foundation
import SwiftData

@Model
class Player {
    var id: UUID = UUID() // Unique identifier
    var index: Int
    var damage: Int
    var levelCounters: Int
    var preparationCounters: Int
    var lashCounters: Int
    var enlightenmentCounters: Int
    var floatingMemory: Int
    var damageHistory: [Int]
    
    init(id: UUID = UUID(), index: Int, damage: Int = 0, levelCounters: Int = 0, preparationCounters: Int = 0, lashCounters: Int = 0, enlightenmentCounters: Int = 0, floatingMemory: Int = 0, damageHistory: [Int] = []) {
            self.id = id
            self.index = index
            self.damage = damage
            self.levelCounters = levelCounters
            self.preparationCounters = preparationCounters
            self.lashCounters = lashCounters
            self.enlightenmentCounters = enlightenmentCounters
            self.floatingMemory = floatingMemory
            self.damageHistory = damageHistory
        }
}
