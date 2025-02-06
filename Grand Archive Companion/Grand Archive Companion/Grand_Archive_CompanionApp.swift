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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .background {
                        let fetchedPlayers = Player.load(context: modelContext)
                            if !fetchedPlayers.isEmpty {
                                Player.save(players: fetchedPlayers, context: modelContext)
                            }
                    }
                }
        }.modelContainer(for: [Player.self, Deck.self, Match.self, Damage.self])
    }
}
