//
//  RadialMenu.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

private struct RadialMenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title)
            .background(Color.black.opacity(configuration.isPressed ? 0.5 : 1))
            .clipShape(Circle())
            .foregroundStyle(.white)
    }
}
    

struct RadialButton {
    let label: String
    let image: Image
    let imageSize: CGSize
    let action: () -> Void
}

struct RadialMenu: View {
    @State private var isExpanded = false
    @State private var isShowingSheet = false
    
    let title: String
    let closedImage: Image
    let openImage: Image
    let buttons: [RadialButton]
    var direction = Angle(degrees: 0)
    var range = Angle(degrees: 160)
    var distance: CGFloat = 100
    var animation = Animation.default
    
    var body: some View {
        ZStack {
            Button {
                if UIAccessibility.isVoiceOverRunning {
                    isShowingSheet.toggle()
                } else {
                    isExpanded.toggle()
                }
            } label: {
                isExpanded ? openImage : closedImage
            }
            .accessibility(label: Text(title))
            .buttonStyle(RadialMenuButtonStyle())
            
            // Setting the radial buttons.
            ForEach(0..<buttons.count, id: \.self) { index in
                Button {
                    buttons[index].action()
                    isExpanded.toggle()
                } label: {
                    VStack {
                        buttons[index].image
                            .resizable()
                            .scaledToFit()
                            .frame(width: buttons[index].imageSize.width, height: buttons[index].imageSize.height)
                        Text(buttons[index].label)
                            .font(.custom("Helvetica-Light", size: 10))
                            .textCase(.uppercase)
                    }
                }
                .accessibility(hidden: isExpanded == false)
                .accessibility(label: Text(buttons[index].label))
                .offset(offset(for: index))
                .buttonStyle(RadialMenuButtonStyle())
            }
            .opacity(isExpanded ? 1 : 0)
            .animation(animation, value: isExpanded)
        }
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(title: Text(title), message: nil, buttons:
                buttons.map { btn in
                    ActionSheet.Button.default(Text(btn.label), action: btn.action)
            } + [.cancel()]
            )
        }
    }
    
    func offset(for index: Int) -> CGSize {
        guard isExpanded else { return .zero }
        
        let buttonAngle = range.radians / Double(buttons.count - 1)
        let ourAngle = buttonAngle * Double(index)
        let finalAngle = direction - (range / 2) + Angle(radians: ourAngle)
        
        let finalX = cos(finalAngle.radians - .pi / 2) * distance
        let finalY = sin(finalAngle.radians - .pi / 2) * distance
        
        return CGSize(width: finalX, height: finalY)
    }
}
