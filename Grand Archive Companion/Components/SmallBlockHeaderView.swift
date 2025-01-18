//
//  SmallBlockHeaderView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI

struct SmallBlockHeaderView: View {
    
    @State var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
                .padding([.top, .leading], 5)
                .font(.system(size: 13, weight: .medium))
                .textCase(.uppercase)
            Spacer()
        }
    }
}

#Preview {
    SmallBlockHeaderView(title: "Test")
}
