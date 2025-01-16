//
//  CounterButtonView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

private struct CounterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title)
            .background(Color.background.opacity(configuration.isPressed ? 0.5 : 1))
            .clipShape(Circle())
            .foregroundStyle(.white)
    }
}

struct CounterButtonView: View {
    
    @State var iconName: String
    @State var count: Int = 0
    
    @State private var size: CGSize = CGSize(width: 30, height: 30)
    
    var onLongPress: () -> Void
    
    var body: some View {
        Button {
            incrementValue()
        } label: {
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
        }
        .buttonStyle(CounterButtonStyle())
        .simultaneousGesture(
            LongPressGesture()
                .onEnded { _ in
                    onLongPress()
                }
        )
        .onTapGesture(count: 2) {
            decrementValue()
        }
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
