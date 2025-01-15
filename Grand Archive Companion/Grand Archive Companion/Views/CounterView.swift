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
        
        let champs: [Champion] =  [
            .init(name: "Minthe, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
            .init(name: "Mordred, Flawless Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2),
            .init(name: "Lorraine, Wandering Warrior", lineage: "", jobs: ["Warrior"], health: 20, level: 1),
            .init(name: "Lorraine, Spirit Ruler", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
        ]
        
        VStack {
            if numberOfPlayers > 1 {
                ZStack {
                    Color.red.ignoresSafeArea(.all)
                    PlayerCounterView(backgroundColor: .red, fontColor: .white, championArray: champs)
                        .rotationEffect(.degrees(180))
                } .padding(.bottom, -5)
            }
            PlayerCounterView(backgroundColor: .blue, fontColor: .white, championArray: champs)
                .padding(.top, -5)
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
