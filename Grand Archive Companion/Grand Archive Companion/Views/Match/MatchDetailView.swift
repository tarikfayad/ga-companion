//
//  MatchDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/6/25.
//

import SwiftUI

struct MatchDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var match: Match
    
    var body: some View {
        VStack {
            Text("DECKS")
                .font(.caption)
            HStack {
                MatchRowView(match: match){ _ in }
            }
            
            Divider()
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .overlay(.secondary)
                .padding(.vertical, 5)
            
            if let notes = match.notes, !notes.isEmpty {
                Text("NOTES")
                    .font(.caption)
                Text(notes)
            }
            
            if let playerOneDamageHistory = match.playerOneDamageHistory, !playerOneDamageHistory.isEmpty {
                Divider()
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                    .overlay(.secondary)
                    .padding(.vertical, 5)
                
                if let playerTwoDamageHistory = match.playerTwoDamageHistory, !playerTwoDamageHistory.isEmpty {
                    HistoryView(multiplayer: true, playerOneColor: .playerBlue, playerTwoColor: .playerPink, playerOneDamageHistory: playerOneDamageHistory, playerTwoDamageHistory: playerTwoDamageHistory)
                } else {
                    HistoryView(multiplayer: false, playerOneColor: .playerBlue, playerOneDamageHistory: playerOneDamageHistory)
                }
            }
            
        }.applyBackground()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back
                }) {
                    HStack {
                        Image(systemName: "arrow.backward") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Match Details")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
