//
//  ContentView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToPlayerView = false
    @State private var navigateToCardView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea(.all)
                VStack {
                    Text("Grand Archive Companion")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    Button {
                        navigateToPlayerView = true
                    } label: {
                        Text("Start")
                            .frame(width:270, height:27)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.playerBlue)
                    
                    Button {
                        navigateToCardView = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Card Search")
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
            }
            .navigationDestination(isPresented: $navigateToPlayerView) {
                SelectPlayersView()
            }
            .navigationDestination(isPresented: $navigateToCardView) {
                CardSearchView()
            }
        }
    }
}

#Preview {
    ContentView()
}
