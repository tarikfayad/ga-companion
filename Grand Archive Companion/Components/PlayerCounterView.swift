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
    
    @State private var damageCounter: Int = 0
    
    @State private var leftIsTouched: Bool = false
    @State private var rightIsTouched: Bool = false
    @State var isSinglePlayer: Bool = true
    @State var isTopPlayer: Bool = false
    
    @State private var menuButtonSize: CGSize = CGSize(width: 35, height: 35)
    
    @State private var showLevelCounter = false
    @State private var showPreparationCounter = false
    @State private var showEnlightenmentCounter = false
    @State private var showLashCounter = false
    @State private var showFloatingMemoryCounter = false
    
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Lvl", image: Image("Level"), imageSize: menuButtonSize, action: levelTapped),
            RadialButton(label: "Prep", image: Image("Preparation"), imageSize: menuButtonSize, action: preparationTapped),
            RadialButton(label: "Enl", image: Image("Enlightenment"), imageSize: menuButtonSize, action: enlightenmentTapped),
            RadialButton(label: "Lash", image: Image("Lash"), imageSize: menuButtonSize, action: lashTapped),
            RadialButton(label: "Fl Mem", image: Image("FloatingMemory"), imageSize: menuButtonSize, action: floatingMemoryTapped),
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                
                VStack {
                    let largeFontSize = geometry.size.height / 4
                    
                    HStack {
                        Text("—")
                            .frame(width: 30)
                            .font(.custom("Helvetica", size: largeFontSize / 3))
                            .opacity(0.5)
                        
                        Text(String(damageCounter))
                            .frame(minWidth: 200, minHeight: 100)
                            .font(.custom("Helvetica-Bold", size: largeFontSize))
                            .padding(.bottom, -1 * largeFontSize / 10)
                            .padding(.top, -1 * largeFontSize / 10)
                        
                        Text("+")
                            .frame(width: 30)
                            .font(.custom("Helvetica", size: largeFontSize / 3))
                            .opacity(0.5)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, isTopPlayer ? 35 : 0)
                }
                
                HStack {
                    Rectangle()
                        .frame(width: geometry.size.width / 2)
                        .ignoresSafeArea(.all)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in leftIsTouched = true }
                                .onEnded { _ in
                                    leftIsTouched = false
                                    if damageCounter > 0 { // Only reduce damage counters if they're above 0.
                                        damageCounter -= 1
                                    }
                                }
                        )
                        .foregroundStyle(leftIsTouched ? .black.opacity(0.4) : .clear)
                    
                    Rectangle()
                        .frame(width: geometry.size.width / 2)
                        .ignoresSafeArea(.all)
                        .contentShape(Rectangle()) // Necessary to make the tap gesture work
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    rightIsTouched = true
                                }
                                .onEnded { value in
                                    damageCounter += 1
                                    rightIsTouched = false
                                }
                        )
                        .foregroundStyle(rightIsTouched ? .black.opacity(0.4) : .clear)
                }
                
                VStack {
                    if !isSinglePlayer {createCounterViews().padding(.top, 20)} // Placing the counters at the top if multiple people are tracking.
                    
                    Spacer()
                    
                    VStack {
                        
                        if isSinglePlayer {createCounterViews()} // Placing the counters right above the menu if only one person is tracking.
                        RadialMenu(title: "Counters", closedImage: Image(systemName: "ellipsis.circle"), openImage: Image(systemName: "multiply.circle.fill"), buttons: buttons, animation: .interactiveSpring(response: 0.4, dampingFraction: 0.6))
                    }.padding(.bottom, isTopPlayer ? 35 : 0)
                }
                
            } .foregroundStyle(fontColor)
        }
    }
    
    func createCounterViews() -> some View {
        return HStack {
            if showLevelCounter {
                CounterButtonView(iconName: "Level"){
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
    PlayerCounterView(backgroundColor: .blue, fontColor: .white)
}
