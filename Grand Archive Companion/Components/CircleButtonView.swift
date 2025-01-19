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
    let buttonSize: CGFloat = 20
    let padding: CGFloat = 15
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
    }
}

#Preview {
    CircleButtonView(imageName: "magnifyingglass", tintColor: Color.black){}
}
