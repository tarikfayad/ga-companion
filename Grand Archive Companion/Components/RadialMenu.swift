//
//  RadialMenu.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

struct RadialButton {
    let label: String
    let image: Image
    let action: () -> Void
}

struct RadialMenu: View {
    @State private var isExpanded = false
    
    let title: String
    let closedImage: Image
    let openImage: Image
    let buttons: [RadialButton]
    var direction = Angle(degrees: 0)
    var range = Angle(degrees: 90)
    var distance: CGFloat = 100
    var animation = Animation.default
    
    var body: some View {
        ZStack {
            Button {
                isExpanded.toggle()
            } label: {
                isExpanded ? openImage : closedImage
            }
            .accessibility(label: Text(title))
            
            // Setting the radial buttons.
            ForEach(0..<buttons.count, id: \.self) { index in
                Button {
                    buttons[index].action()
                    isExpanded.toggle()
                } label: {
                    buttons[index].image
                }
                .accessibility(hidden: isExpanded == false)
                .accessibility(label: Text(buttons[index].label))
                .offset(offset(for: index))
            }
            .opacity(isExpanded ? 1 : 0)
            .animation(animation, value: isExpanded)
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
