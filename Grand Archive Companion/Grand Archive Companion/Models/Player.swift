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
    var damage: Int
    var levelCounters: Int
    var preparationCounters: Int
    var lashCounters: Int
    var enlightenmentCounters: Int
    var floatingMemory: Int
    var incrementCount: [Int]
    var decrementCount: [Int]
    
    init(id: UUID, damage: Int, levelCounters: Int, preparationCounters: Int, lashCounters: Int, enlightenmentCounters: Int, floatingMemory: Int, incrementCount: [Int], decrementCount: [Int]) {
        self.id = id
        self.damage = damage
        self.levelCounters = levelCounters
        self.preparationCounters = preparationCounters
        self.lashCounters = lashCounters
        self.enlightenmentCounters = enlightenmentCounters
        self.floatingMemory = floatingMemory
        self.incrementCount = incrementCount
        self.decrementCount = decrementCount
    }
}
