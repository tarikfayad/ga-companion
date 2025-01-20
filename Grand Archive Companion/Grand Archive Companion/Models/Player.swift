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
    var incrementHistory: [Int]
    var decrementHistory: [Int]
    
    init(id: UUID, index: Int, damage: Int, levelCounters: Int, preparationCounters: Int, lashCounters: Int, enlightenmentCounters: Int, floatingMemory: Int, incrementHistory: [Int], decrementHistory: [Int]) {
        self.id = id
        self.index = index
        self.damage = damage
        self.levelCounters = levelCounters
        self.preparationCounters = preparationCounters
        self.lashCounters = lashCounters
        self.enlightenmentCounters = enlightenmentCounters
        self.floatingMemory = floatingMemory
        self.incrementHistory = incrementHistory
        self.decrementHistory = decrementHistory
    }
}
