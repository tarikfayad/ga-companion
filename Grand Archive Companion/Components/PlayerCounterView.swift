//
//  PlayerCounterView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct PlayerCounterView: View {
    
    @State var backgroundColor: Color // We'll set the background color based on the player number
    @State var fontColor: Color
    @State var championArray: [Champion] // An ordered array sorted by level. The level 0 champion will always be first.
    
    @State private var currentHealth: Int = 0
    @State private var currentChampion: Champion?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                
                VStack {
                    if let currentChampion = currentChampion {
                        Text(currentChampion.name)
                            .font(.system(size: 17))
                            .padding(.bottom, -30)
                        
                        Text(String(currentHealth))
                            .font(.custom("Helvetica-Bold", size: 300))
                            .padding(.top, -30)
                    }
                }
                
                VStack {
                    Rectangle()
                        .frame(height: geometry.size.height / 2)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .onTapGesture {
                            currentHealth += 1
                        }
                    
                    Rectangle()
                        .frame(height: geometry.size.height / 2)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .onTapGesture {
                            if currentHealth > 0 { // Only reduce the health if it's above 0.
                                currentHealth -= 1
                            }
                            print(currentHealth)
                        }
                }.foregroundStyle(.clear)
                
                VStack {
                    HStack {
                        // Levelup Buttons will go here
                        Spacer()
                        
                        VStack {
                            Image(systemName: "arrow.up.circle")
                            Text("Level\nUp")
                            
                            Image(systemName: "arrow.down.circle")
                            Text("Level\nDown")
                        }.multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                }
                
            } .foregroundStyle(fontColor)
                .onAppear() {
                    if let champion = championArray.first {
                        currentChampion = champion
                        currentHealth = champion.health
                    }
                }
        }
    }
}

#Preview {
    let champ =  Champion.init(name: "Mordred, Flawless Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2)
    PlayerCounterView(backgroundColor: .blue, fontColor: .white, championArray: [champ])
}
