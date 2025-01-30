//
//  AddMatchView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI

struct AddMatchView: View {
    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            VStack {
                DeckCreationView()
                    .padding(.horizontal, 5)
                
                Text("VS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding()
                
                DeckCreationView(deckString: "Opponent's Deck", isUserDeck: false)
                    .padding(.horizontal, 5)
            }
        }
        .foregroundStyle(.white)
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
                Text("Add a Match")
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

#Preview {
    NavigationStack {
        AddMatchView()
    }
}
