//
//  DeckCreationView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/30/25.
//

import SwiftUI

struct DeckCreationView: View {
    @State private var deckName: String = ""
    @State private var selectedChampion: Champion?
    @State private var baseElement: Element?
    @State private var userDidWin: Bool = false
    @State var deckString: String = "Your Deck"
    
    @State var isUserDeck: Bool = true
    
    var body: some View {
        VStack {
            Text(deckString)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.top, 10)
            
            TextField("Enter a deck name...", text: $deckName)
                .preferredColorScheme(.dark)
            HStack {
                Menu("Champion ") { // This is toxic but unless I include a blank space after the word Champion then it gets truncated
                    Button("Option 1") { print("Option 1 selected") }
                    Button("Option 2") { print("Option 2 selected") }
                    Button("Option 3") { print("Option 3 selected") }
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
                .background(Color.secondary)
                
                Menu("Base Element") {
                    Button("Option 1") { print("Option 1 selected") }
                    Button("Option 2") { print("Option 2 selected") }
                    Button("Option 3") { print("Option 3 selected") }
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)
                .background(Color.secondary)
            }
            
            if isUserDeck {
                HStack {
                    Text("Lost / Won")
                    Toggle("Lose : Win", isOn: $userDidWin)
                        .labelsHidden()
                        .background(userDidWin ? Color.green : Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }.padding(.horizontal, 5)
            }
        }
        .padding()
        .foregroundStyle(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    DeckCreationView()
        .background(Color.gray.opacity(0.2))
}
