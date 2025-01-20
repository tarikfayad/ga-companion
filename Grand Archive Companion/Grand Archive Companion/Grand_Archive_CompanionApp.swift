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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [Player.self])
    }
}
