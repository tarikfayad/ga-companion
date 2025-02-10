//
//  DeckListView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/10/25.
//

import SwiftUI

struct DeckListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var deck: Deck? // Not actually optional but making it so so preview works easily
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .applyBackground()
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back
                }) {
                    HStack {
                        Image(systemName: "arrow.backward") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .principal) {
//                Text(deck.name)
//                    .foregroundStyle(.white)
//                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeckListView()
    }
}
