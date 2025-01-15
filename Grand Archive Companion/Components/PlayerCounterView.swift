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
                            Button {
                                levelUp()
                            } label: {
                                VStack {
                                    Image(systemName: "arrow.up.circle")
                                    Text("Level\nUp")
                                }
                            }
                            .frame(width: 75, height: 75)
                            .background(.black)
                            .cornerRadius(5)
                            .padding()
                            
                            Button {
                                levelDown()
                            } label: {
                                VStack {
                                    Text("Level\nDown")
                                    Image(systemName: "arrow.down.circle")
                                }
                            }
                            .frame(width: 75, height: 75)
                            .background(.black)
                            .cornerRadius(5)
                            .padding(.top, -15)
                        }
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                
            } .foregroundStyle(fontColor)
                .onAppear() {
                    let sortedChampions = championArray.sorted(by: { $0.level < $1.level })
                    if let champion = sortedChampions.first {
                        currentChampion = champion
                        currentHealth = champion.health
                    }
                }
        }
    }
    
    func levelUp() {
        // Only leveling up if the champion level is below three. We cannot level beyond this.
        // need to take into account cases where people have multiple champions of the same level.
        // In this case, we need to show an action sheet and let them select which champion they would like to level into.
        if currentChampion!.level < 3 {
            let nextChampion = championArray.first(where: { $0.level == currentChampion!.level + 1 })
            let healthDifference = nextChampion!.health - currentChampion!.health
            currentChampion = nextChampion
            currentHealth += healthDifference
        }
    }
    
    func levelDown() {
        if currentChampion!.level > 0 {
            let previousChampion = championArray.first(where: { $0.level == currentChampion!.level - 1 })
            let healthDifference =  currentChampion!.health - previousChampion!.health
            currentChampion = previousChampion
            currentHealth -= healthDifference
        }
    }
}

#Preview {
    let champs: [Champion] =  [
        .init(name: "Minthe, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
        .init(name: "Mordred, Flawless Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2),
        .init(name: "Lorraine, Wandering Warrior", lineage: "", jobs: ["Warrior"], health: 20, level: 1),
        .init(name: "Lorraine, Spirit Ruler", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    ]
    PlayerCounterView(backgroundColor: .blue, fontColor: .white, championArray: champs)
}
