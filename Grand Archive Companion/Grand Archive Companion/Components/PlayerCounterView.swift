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
    @ObservedObject var player: Player
    
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
    
    @State private var incrementTapCount: Int = 0
    @State private var incrementLastTapTime: Date? = nil
    @State private var incrementShowTapCount: Bool = false
    
    @State private var decrementTapCount: Int = 0
    @State private var decrementLastTapTime: Date? = nil
    @State private var decrementShowTapCount: Bool = false
    
    @State private var timer: Timer? = nil
    private let timerDuration = 0.5
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var buttons: [RadialButton] {
        [
            RadialButton(label: "Lvl", image: Image("level"), imageSize: menuButtonSize, action: levelTapped),
            RadialButton(label: "Prep", image: Image("preparation"), imageSize: menuButtonSize, action: preparationTapped),
            RadialButton(label: "Enl", image: Image("enlightenment"), imageSize: menuButtonSize, action: enlightenmentTapped),
            RadialButton(label: "Lash", image: Image("lash"), imageSize: menuButtonSize, action: lashTapped),
            RadialButton(label: "Fl Mem", image: Image("floating-memory"), imageSize: menuButtonSize, action: floatingMemoryTapped),
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor.ignoresSafeArea(.all)
                
                VStack {
                    let largeFontSize = geometry.size.height / 4
                    
                    HStack {
                        VStack {
                            Text("—")
                                .frame(width: 30)
                                .font(.custom("Helvetica", size: largeFontSize / 3))
                                .opacity(decrementShowTapCount ? 1 : 0.5)
                            
                            if decrementShowTapCount {
                                Text(String(decrementTapCount))
                                    .font(.custom("Helvetica", size: largeFontSize / 5.5))
                                    .opacity(decrementShowTapCount ? 1 : 0.5)
                            }
                        }.animation(.easeInOut(duration: 0.2), value: decrementShowTapCount)
                        
                        Text(String(player.damage))
                            .frame(minWidth: 200, minHeight: 100)
                            .font(.custom("Helvetica-Bold", size: largeFontSize))
                            .padding(.bottom, -1 * largeFontSize / 10)
                            .padding(.top, -1 * largeFontSize / 10)
                        
                        VStack {
                            Text("+")
                                .frame(width: 30)
                                .font(.custom("Helvetica", size: largeFontSize / 3))
                                .opacity(incrementShowTapCount ? 1 : 0.5)
                            
                            if incrementShowTapCount {
                                Text(String(incrementTapCount))
                                    .font(.custom("Helvetica", size: largeFontSize / 5.5))
                                    .opacity(incrementShowTapCount ? 1 : 0.5)
                            }
                        }.animation(.easeInOut(duration: 0.2), value: incrementShowTapCount)
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
                                    if player.damage > 0 { // Only reduce damage counters if they're above 0.
                                        player.damage -= 1
                                        handleDecrementTap()
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
                                    player.damage += 1
                                    handleIncrementTap()
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
                
            }
            .foregroundStyle(fontColor)
            .onChange(of: player) {
                if player.levelCounters > 0 { showLevelCounter = true }
                if player.preparationCounters > 0 { showPreparationCounter = true }
                if player.enlightenmentCounters > 0 { showEnlightenmentCounter = true }
                if player.lashCounters > 0 { showLashCounter = true }
                if player.floatingMemory > 0 { showFloatingMemoryCounter = true }
            }
        }
    }
    
    func createCounterViews() -> some View {
        return HStack {
            if showLevelCounter {
                CounterButtonView(iconName: "level", count: $player.levelCounters, onLongPress: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showLevelCounter.toggle()
                        hapticFeedback.notificationOccurred(.success)
                    }
                })
            }
            
            if showPreparationCounter {
                CounterButtonView(iconName: "preparation", count: $player.preparationCounters, onLongPress: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showPreparationCounter.toggle()
                        hapticFeedback.notificationOccurred(.success)
                    }
                })
            }
            
            if showEnlightenmentCounter {
                CounterButtonView(iconName: "enlightenment", count: $player.enlightenmentCounters, onLongPress: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showEnlightenmentCounter.toggle()
                        hapticFeedback.notificationOccurred(.success)
                    }
                })
            }
            
            if showLashCounter {
                CounterButtonView(iconName: "lash", count: $player.lashCounters, onLongPress: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showLashCounter.toggle()
                        hapticFeedback.notificationOccurred(.success)
                    }
                })
            }
            
            if showFloatingMemoryCounter {
                CounterButtonView(iconName: "floating-memory", count: $player.floatingMemory, onLongPress: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showFloatingMemoryCounter.toggle()
                        hapticFeedback.notificationOccurred(.success)
                    }
                })
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
    
    // MARK: - Tap Counter Functions
    func handleIncrementTap() {
        let currentTime = Date()
        timer?.invalidate()
        
        incrementTapCount += 1
        incrementShowTapCount = true
        
        timer = Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: false) { _ in
            addDamage(to: player, value: incrementTapCount)
            resetTapCount()
        }
        
        incrementLastTapTime = currentTime
    }
    
    func handleDecrementTap() {
        let currentTime = Date()
        timer?.invalidate()
        
        decrementTapCount += 1
        decrementShowTapCount = true
        
        timer = Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: false) { _ in
            addDamage(to: player, value: decrementTapCount * -1)
            resetTapCount()
        }
        
        decrementLastTapTime = currentTime
    }
    
    func resetTapCount() {
        incrementShowTapCount = false
        decrementShowTapCount = false
        incrementTapCount = 0
        decrementTapCount = 0
    }
    
    private func addDamage(to player: Player, value: Int) {
        let damage = Damage(player: player, value: value, sortIndex: retrieveHighestSortIndex(player: player) + 1)
        player.damageHistory.append(damage)
    }
    
    private func retrieveHighestSortIndex(player: Player) -> Int {
        return player.damageHistory.max(by: { $0.sortIndex < $1.sortIndex })?.sortIndex ?? 0
    }
}

#Preview {
    @Previewable @State var player = Player(index: 1)
    PlayerCounterView (
        backgroundColor: .blue,
        fontColor: .white, player: player
    )
}
