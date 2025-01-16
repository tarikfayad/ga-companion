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
    
    var body: some View {
        
        VStack {
            if numberOfPlayers > 1 {
                ZStack {
                    PlayerCounterView(backgroundColor: .playerPink, fontColor: .white, isSinglePlayer: false, isTopPlayer: true)
                        .rotationEffect(.degrees(180))
                        .ignoresSafeArea(.all)
                } .padding(.bottom, 10)
                PlayerCounterView(backgroundColor: .playerBlue, fontColor: .white, isSinglePlayer: false)
                    .padding(.top, -20)
            } else {
                PlayerCounterView(backgroundColor: .playerBlue, fontColor: .white)
                    .padding(.top, -20)
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
    }
    
}

#Preview ("One Player") {
    CounterView(numberOfPlayers: 1)
}

#Preview ("Two Players") {
    CounterView(numberOfPlayers: 2)
}
