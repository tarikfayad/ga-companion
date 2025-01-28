//
//  ImageLabelButtonView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import SwiftUI

struct ImageLabelButtonView: View {
    @State var imageName: String = "clock.arrow.trianglehead.counterclockwise.rotate.90"
    @State var title: String = "Match History"
    @State var fontColor: Color = .black
    @State var tintColor: Color = .white
    var onButtonTap: () -> Void
    
    var body: some View {
        Button {
            onButtonTap()
        } label: {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(.bottom, 8)
                Text(title)
                    .font(.custom("Helvetica-Light", size: 14))
            }
            .frame(width: 112, height: 112)
            .foregroundStyle(fontColor)
        }
        .buttonStyle(.borderedProminent)
        .tint(tintColor)
    }
}

#Preview {
    ImageLabelButtonView(){}
        .frame(width: 300, height: 300)
        .background(Color.blue)
}
