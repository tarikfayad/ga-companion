//
//  StatBlockView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI

struct StatBlockView: View {
    
    @State var statName: String
    @State var statValue: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
                .opacity(0.15)
            VStack(alignment: .center) {
                Text(statName)
                    .font(.system(size: UIScreen.main.bounds.width/14 - 10))
                    .padding(.bottom, 2)
                
                Text(statValue)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }
        }
        .frame(width: UIScreen.main.bounds.width/3 - 10, height: 95)
        .cornerRadius(5)
        .foregroundStyle(.white)
    }
}

#Preview {
    StatBlockView(statName: "Memory Cost", statValue: "1")
}
