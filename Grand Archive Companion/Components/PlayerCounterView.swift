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
    
    @State private var damageCounter: Int = 0
    @State private var currentChampion: Champion?
    @State private var nextChampions: [Champion]?
    @State private var previousChampions: [Champion]? = []
    
    @State private var isShowingLevelUpSheet: Bool = false
    @State private var isDead: Bool = false
    
    @State private var menuButtonSize: CGSize = CGSize(width: 35, height: 35)
    
    @State private var showLevelCounter = false
    @State private var showPreparationCounter = false
    @State private var showEnlightenmentCounter = false
    @State private var showLashCounter = false
    @State private var showFloatingMemoryCounter = false
    
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Level Counter", image: Image("Level"), imageSize: menuButtonSize, action: levelTapped),
            RadialButton(label: "Preparation Counter", image: Image("Preparation"), imageSize: menuButtonSize, action: preparationTapped),
            RadialButton(label: "Enlightenment Counter", image: Image("Enlightenment"), imageSize: menuButtonSize, action: enlightenmentTapped),
            RadialButton(label: "Lash Counter", image: Image("Lash"), imageSize: menuButtonSize, action: lashTapped),
            RadialButton(label: "Floating Memory", image: Image("FloatingMemory"), imageSize: menuButtonSize, action: floatingMemoryTapped),
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                
                VStack {
                    if let currentChampion = currentChampion {
                        let largeFontSize = geometry.size.height / 3
                        Text(String(damageCounter))
                            .font(.custom("Helvetica-Bold", size: largeFontSize))
                            .padding(.bottom, -1 * largeFontSize / 10)
                            .padding(.top, -1 * largeFontSize / 10)
                        
                        Text(currentChampion.name)
                            .font(.system(size: 17, weight: .bold))
                            .padding(.top, -1 * largeFontSize / 10)
                            .textCase(.uppercase)
                    }
                }
                
                VStack {
                    Rectangle()
                        .frame(height: geometry.size.height / 2)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .onTapGesture {
                            damageCounter += 1
                            checkIfDead()
                        }
                    
                    Rectangle()
                        .frame(height: geometry.size.height / 2)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .onTapGesture {
                            if damageCounter > 0 { // Only reduce damage counters if they're above 0.
                                damageCounter -= 1
                                checkIfDead()
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
                    
                    VStack {
                        HStack {
                            if showLevelCounter {
                                CounterButtonView(iconName: "Level", count: currentChampion!.level){
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showLevelCounter.toggle()
                                    }
                                }
                            }
                            
                            if showPreparationCounter {
                                CounterButtonView(iconName: "Preparation"){
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showPreparationCounter.toggle()
                                    }
                                }
                            }
                            
                            if showEnlightenmentCounter {
                                CounterButtonView(iconName: "Enlightenment"){
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showEnlightenmentCounter.toggle()
                                    }
                                }
                            }
                            
                            if showLashCounter {
                                CounterButtonView(iconName: "Lash"){
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showLashCounter.toggle()
                                    }
                                }
                            }
                            
                            if showFloatingMemoryCounter {
                                CounterButtonView(iconName: "FloatingMemory"){
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showFloatingMemoryCounter.toggle()
                                    }
                                }
                            }
                        }
                        
                        RadialMenu(title: "Counters", closedImage: Image(systemName: "ellipsis.circle"), openImage: Image(systemName: "multiply.circle.fill"), buttons: buttons, animation: .interactiveSpring(response: 0.4, dampingFraction: 0.6))
                    }
                }
                
            } .foregroundStyle(fontColor)
                .onAppear() {
                    let sortedChampions = championArray.sorted(by: { $0.level < $1.level })
                    if let champion = sortedChampions.first {
                        currentChampion = champion
                    }
                }
                .alert("You Died 💀", isPresented: $isDead) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Your champion has perished!")
                        }
        }
    }
    
        // MARK: - Helper Functions
    
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
                    previousChampions?.append(currentChampion!)
                    currentChampion = nextChampion
                    checkIfDead()
                } else {
                    // If there are multiple, display an action sheet with the champions to select from.
                    isShowingLevelUpSheet = true
                }
            }
        } else {
            // If a champion is passed to the function, we use that as the basis to level up.
            let nextChampion = champion
            previousChampions?.append(currentChampion!)
            currentChampion = nextChampion
            checkIfDead()
        }
    }
    
    func levelDown() {
        if currentChampion!.level > 0 {
            let previousChampion = previousChampions?.last
            currentChampion = previousChampion
            previousChampions?.removeLast()
            checkIfDead()
        }
    }
    
    func checkIfDead() {
        if damageCounter >= currentChampion!.health { isDead = true }
    }
                     
    // MARK: - Radial Button Functions
    func levelTapped() {
        showLevelCounter.toggle()
    }
    
    func preparationTapped() {
        showPreparationCounter.toggle()
    }
    
    func enlightenmentTapped() {
        showEnlightenmentCounter.toggle()
    }
    
    func lashTapped() {
        showLashCounter.toggle()
    }
    
    func floatingMemoryTapped() {
        showFloatingMemoryCounter.toggle()
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
