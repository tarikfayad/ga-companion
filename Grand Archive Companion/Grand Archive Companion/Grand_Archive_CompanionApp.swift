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
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var playerOne: Player = Player(index: 1)
    @State private var playerTwo: Player = Player(index: 2)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        Player.save(players: [playerOne, playerTwo], context: modelContext)
                    }
                }
        }.modelContainer(for: [Player.self])
    }
}
