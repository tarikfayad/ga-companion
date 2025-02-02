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
    @State private var navigateToHistoryView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea(.all)
                VStack {
                    Image("Proxia-Text")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("Grand Archive\nCompanion")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .textCase(.uppercase)
                    
                    Button {
                        navigateToPlayerView = true
                    } label: {
                        Text("Start")
                            .frame(width:290, height:27)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(.playerBlue)
                    
                    HStack {
                        ImageLabelButtonView(imageName: "magnifyingglass", title: "Card Search", buttonSize: 78){
                            navigateToCardView = true
                        }
                        
                        ImageLabelButtonView(imageName: "clock.arrow.trianglehead.counterclockwise.rotate.90", title: "Match History", fontColor: .white, tintColor: .playerPink, buttonSize: 78){
                            navigateToHistoryView = true
                        }
                        
                        ImageLabelButtonView(imageName: "info.circle", title: "Deck Stats", fontColor: .white, tintColor: .playerGreen, buttonSize: 78){
                            // Go to deck stats view
                        }
                    }.padding(.top, -10)
                }
            }
            .navigationDestination(isPresented: $navigateToPlayerView) {
                SelectPlayersView()
            }
            .navigationDestination(isPresented: $navigateToCardView) {
                CardSearchView()
            }
            .navigationDestination(isPresented: $navigateToHistoryView){
                DeckHistoryView()
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
