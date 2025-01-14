//
//  Champion.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/14/25.
//

import Foundation
import SwiftData

@Model
class Champion {
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
        return "\(name.lowercased())+.png"
    }
}
