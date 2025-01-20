import Foundation
import SwiftData

@Model
class Player: Codable {
    var id: UUID = UUID() // Unique identifier
    var index: Int
    var damage: Int
    var levelCounters: Int
    var preparationCounters: Int
    var lashCounters: Int
    var enlightenmentCounters: Int
    var floatingMemory: Int
    
    @Attribute(.transformable(by: NSValueTransformerName.secureUnarchiveFromDataTransformerName.rawValue))
    var damageHistory: [Damage] // The problem child and the reason I needed to write encode and decode functions.
    
    init(id: UUID = UUID(), index: Int, damage: Int = 0, levelCounters: Int = 0, preparationCounters: Int = 0, lashCounters: Int = 0, enlightenmentCounters: Int = 0, floatingMemory: Int = 0, damageHistory: [Damage] = []) {
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
    
    // Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(index, forKey: .index)
        try container.encode(damage, forKey: .damage)
        try container.encode(levelCounters, forKey: .levelCounters)
        try container.encode(preparationCounters, forKey: .preparationCounters)
        try container.encode(lashCounters, forKey: .lashCounters)
        try container.encode(enlightenmentCounters, forKey: .enlightenmentCounters)
        try container.encode(floatingMemory, forKey: .floatingMemory)
        try container.encode(damageHistory, forKey: .damageHistory)
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        index = try container.decode(Int.self, forKey: .index)
        damage = try container.decode(Int.self, forKey: .damage)
        levelCounters = try container.decode(Int.self, forKey: .levelCounters)
        preparationCounters = try container.decode(Int.self, forKey: .preparationCounters)
        lashCounters = try container.decode(Int.self, forKey: .lashCounters)
        enlightenmentCounters = try container.decode(Int.self, forKey: .enlightenmentCounters)
        floatingMemory = try container.decode(Int.self, forKey: .floatingMemory)
        damageHistory = try container.decode([Damage].self, forKey: .damageHistory)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case index
        case damage
        case levelCounters
        case preparationCounters
        case lashCounters
        case enlightenmentCounters
        case floatingMemory
        case damageHistory
    }
    
    static func save(players: [Player], context: ModelContext) {
        players.forEach { context.insert($0) }
        do {
            try context.save()
        } catch {
            print("Failed to save players: \(error)")
        }
    }
    
    static func load(context: ModelContext) -> [Player] {
        let fetchDescriptor = FetchDescriptor<Player>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to load players: \(error)")
            return []
        }
    }
    
    static func deleteAll(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Player>()
        do {
            let players = try context.fetch(fetchDescriptor)
            for player in players {
                context.delete(player)
            }
            try context.save()
            print("All players deleted successfully.")
        } catch {
            print("Failed to delete players: \(error)")
        }
    }
    
    static func arePlayersSaved(context: ModelContext) -> Bool {
        let fetchDescriptor = FetchDescriptor<Player>()
        do {
            if try context.fetch(fetchDescriptor).isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            return false
        }
    }
}

@Model
class Damage: Codable {
    var id: UUID
    var value: Int
    var sortIndex: Int

    init(id: UUID = UUID(), value: Int, sortIndex: Int) {
        self.id = id
        self.value = value
        self.sortIndex = sortIndex
    }

    // Encoding logic
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(sortIndex, forKey: .sortIndex)
    }

    // Decoding logic
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        value = try container.decode(Int.self, forKey: .value)
        sortIndex = try container.decode(Int.self, forKey: .sortIndex)
    }

    // Coding keys
    enum CodingKeys: String, CodingKey {
        case id
        case value
        case sortIndex
    }
}
