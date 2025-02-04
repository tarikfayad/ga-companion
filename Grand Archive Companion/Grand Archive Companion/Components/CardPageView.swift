//
//  CardPageView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardPageView: View {
    var cards: [Card] = []
    
    var body: some View {
        TabView {
            ForEach(cards, id: \.uuid) { card in
                WebImage(url: card.imageURL)
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing] , 5)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    CardPageView()
}
