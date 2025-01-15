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
    @State private var nextChampions: [Champion]?
    @State private var previousChampions: [Champion]? = []
    
    @State private var isShowingLevelUpSheet: Bool = false
    
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Level Counter", image: Image(systemName: "arrow.up.circle"), action: levelTapped),
            RadialButton(label: "Preparation Counter", image: Image(systemName: "arrow.up.circle"), action: levelTapped),
            RadialButton(label: "Enlightenment Counter", image: Image(systemName: "arrow.up.circle"), action: levelTapped),
            RadialButton(label: "Lash Counter", image: Image(systemName: "arrow.up.circle"), action: levelTapped),
            RadialButton(label: "Floating Memory", image: Image(systemName: "arrow.up.circle"), action: levelTapped),
        ]
    }
    
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
                            .confirmationDialog(
                                "Select a Champion",
                                isPresented: $isShowingLevelUpSheet,
                                titleVisibility: .visible,
                                presenting: nextChampions
                            ) { champions in
                                // Displaying a list of possible next champions for selection.
                                ForEach(champions) { champion in
                                    Button(champion.name) {
                                        levelUp(champion: champion)
                                    }
                                }
                                
                                Button("Cancel", role: .cancel) {}
                            }
                            
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
                    
                    RadialMenu(title: "Counters", closedImage: Image(systemName: "ellipsis.circle"), openImage: Image(systemName: "multiply.circle.fill"), buttons: buttons, animation: .interactiveSpring(response: 0.4, dampingFraction: 0.6))
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
    
    func levelUp(champion: Champion? = nil) {
        // If the function is called without a champion being passed to it, we check to see if there are multiple levelup options. If there aren't we automatically level up.
        if champion == nil {
            // Only leveling up if the champion level is below three. We cannot level beyond this.
            if currentChampion!.level < 3 {
                // Searching for all champions selected that are exactly one level higher than the current champion
                nextChampions = championArray.filter{ $0.level == currentChampion!.level + 1 }
                
                // If there is only one champion that matches the search, automatically level up
                if nextChampions?.count == 1 {
                    let nextChampion = nextChampions?.first
                    let healthDifference = nextChampion!.health - currentChampion!.health
                    previousChampions?.append(currentChampion!)
                    currentChampion = nextChampion
                    currentHealth += healthDifference
                } else {
                    // If there are multiple, display an action sheet with the champions to select from.
                    isShowingLevelUpSheet = true
                }
            }
        } else {
            // If a champion is passed to the function, we use that as the basis to level up.
            let nextChampion = champion
            let healthDifference = nextChampion!.health - currentChampion!.health
            previousChampions?.append(currentChampion!)
            currentChampion = nextChampion
            currentHealth += healthDifference
        }
    }
    
    func levelDown() {
        if currentChampion!.level > 0 {
            let previousChampion = previousChampions?.last
            let healthDifference =  currentChampion!.health - previousChampion!.health
            currentChampion = previousChampion
            currentHealth -= healthDifference
            previousChampions?.removeLast()
        }
    }
                     
    // MARK: - Radial Button Functions
    func levelTapped() {
        print("Level Tapped")
    }
}

#Preview {
    let champs: [Champion] =  [
        .init(name: "Minthe, Spirit of Water", lineage: "", jobs: ["Spirit"], health: 15, level: 0),
        .init(name: "Mordred, Flawless Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2),
//        .init(name: "Mordred, Great Blade", lineage: "", jobs: ["Warrior"], health: 24, level: 2),
        .init(name: "Lorraine, Wandering Warrior", lineage: "", jobs: ["Warrior"], health: 20, level: 1),
        .init(name: "Lorraine, Spirit Ruler", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    ]
    PlayerCounterView(backgroundColor: .blue, fontColor: .white, championArray: champs)
}
