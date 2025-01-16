//
//  Card.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/16/25.
//

import Foundation
import SwiftData

struct Rule: Codable {
    var title: String
    var dateAdded: String
    var description: String
}

@Model
class Card: Equatable {
    var types: [String]
    var classes: [String]
    var subtypes: [String]
    var element: String
    var name: String
    var slug: String
    var effect: String
    var rules: [Rule]
    var flavorText: String
    var memoryCost: Int
    var reserveCost: Int
    var level: Int
    var power: Int
    var life: Int
    var durability: Int
    var speed: Int
    
    init(types: [String], classes: [String], subtypes: [String], element: String, name: String, slug: String, effect: String, rules: [Rule], flavorText: String, memoryCost: Int, reserveCost: Int, level: Int, power: Int, life: Int, durability: Int, speed: Int) {
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
    }
    
    
}
