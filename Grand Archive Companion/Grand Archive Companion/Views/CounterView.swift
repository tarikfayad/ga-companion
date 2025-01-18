//
//  CounterView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct CounterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var numberOfPlayers: Int
    @State private var navigateToCardSearchView = false
    
    var body: some View {
        
        VStack {
            if numberOfPlayers > 1 {
                ZStack {
                    VStack {
                        ZStack {
                            PlayerCounterView(backgroundColor: .playerPink, fontColor: .white, isSinglePlayer: false, isTopPlayer: true)
                                .rotationEffect(.degrees(180))
                                .ignoresSafeArea(.all)
                        }
                        PlayerCounterView(backgroundColor: .playerBlue, fontColor: .white, isSinglePlayer: false)
                    }
                    VStack {
                        Button {
                            navigateToCardSearchView = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(15)
                        }
                        .clipShape(Circle())
                        .buttonStyle(.borderedProminent)
                        .tint(Color.black)
                    }
                }
            } else {
                ZStack {
                    PlayerCounterView(backgroundColor: .playerBlue, fontColor: .white)
                        .padding(.top, -20)
                    
                    VStack {
                        Button {
                            navigateToCardSearchView = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(15)
                        }
                        .clipShape(Circle())
                        .buttonStyle(.borderedProminent)
                        .tint(Color.black)
                        Spacer()
                    }
                }
            }
        }
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
        }
        .navigationDestination(isPresented: $navigateToCardSearchView) {
            CardSearchView()
        }
    }
    
}

#Preview ("One Player") {
    CounterView(numberOfPlayers: 1)
}

#Preview ("Two Players") {
    CounterView(numberOfPlayers: 2)
}
