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
                        HStack {
                            CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black, padding: 15, buttonSize: 20){
                                navigateToCardSearchView = true
                            }
                            
//                            CircleButtonView(imageName: "arrow.counterclockwise.circle", tintColor: Color.black, padding: 10, buttonSize: 30){}
                        }
                    }
                    
                    HStack {
                        VStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward") // Custom back icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                } .foregroundStyle(.white)
                            }
                            .padding([.leading, .top])
                            Spacer()
                        }
                        Spacer()
                    }
                }
            } else {
                ZStack {
                    PlayerCounterView(backgroundColor: .playerBlue, fontColor: .white)
                        .padding(.top, -20)
                    
                    VStack {
                        CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black, padding: 15, buttonSize: 20){
                            navigateToCardSearchView = true
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss() // Go back
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward") // Custom back icon
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                } .foregroundStyle(.white)
                            }
                            .padding([.leading, .top])
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
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
