//
//  CircleButtonView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/19/25.
//

import SwiftUI

struct CircleButtonView: View {
    
    let imageName: String
    let tintColor: Color
    let padding: CGFloat
    let buttonSize: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: buttonSize, height: buttonSize)
                .padding(padding)
        }
        .clipShape(Circle())
        .buttonStyle(.borderedProminent)
        .tint(tintColor)
        .shadow(radius: 5)
    }
}

#Preview {
    CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black, padding: 15, buttonSize: 20){}
}
