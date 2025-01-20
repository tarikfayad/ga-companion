//
//  CounterButtonView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

private struct CounterButtonStyle: ViewModifier {
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.title)
            .background(Color.background.opacity(isPressed ? 0.5 : 1))
            .clipShape(Circle())
            .foregroundStyle(.white)
    }
}

struct CounterButtonView: View {
    
    @State var iconName: String
    @State var count: Int = 0
    
    @State private var size: CGSize = CGSize(width: 30, height: 30)
    @State private var isPressed: Bool = false
    
    var onLongPress: () -> Void
    
    var body: some View {
        VStack {
            Image("\(iconName)")
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .padding(.bottom, -12)
            Text("\(count)")
                .font(.custom("Helvetica-Bold", size: 20))
                .textCase(.uppercase)
        }
        .modifier(CounterButtonStyle(isPressed: isPressed))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { isPressed = true } // Set isPressed when gesture starts
                }
                .onEnded { _ in
                    isPressed = false // Reset isPressed when gesture ends
                }
        )
        .simultaneousGesture (
            TapGesture(count: 2)
                .onEnded {decrementValue()}
                .exclusively(before: TapGesture().onEnded{incrementValue()})
        )
        .simultaneousGesture(
            LongPressGesture()
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    isPressed = false
                    onLongPress()
                }
        )
    }
    
    private func incrementValue() {
        count += 1
    }
    
    private func decrementValue() {
        if count == 0 { return }
        count -= 1
    }
}

#Preview {
    CounterButtonView(iconName: "Level"){}
}
