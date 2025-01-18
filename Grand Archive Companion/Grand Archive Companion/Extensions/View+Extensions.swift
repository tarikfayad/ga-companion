//
//  View+Hidden.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        Group {
            if isHidden {
                self.hidden()
            } else {
                self
            }
        }
    }
    
    func applyBlockStyling() -> some View {
        self
            .frame(width: UIScreen.main.bounds.width - 12)
            .overlay{
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            }
            .border(Color.gray, width: 1)
            .background(Color.white.opacity(0.1))
            .padding(.top, 5)
    }
    
    func applyBlockHeaderStyling() -> some View {
        HStack {
            Text("STATS")
                .foregroundStyle(.gray)
                .padding([.top, .leading, .bottom], 5)
                .font(.system(size: 13, weight: .medium))
            Spacer()
        }
    }
}
