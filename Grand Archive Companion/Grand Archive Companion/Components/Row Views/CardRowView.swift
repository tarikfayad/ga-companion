//
//  CardRowView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardRowView: View {
    @State var card: Card
    
    var body: some View {
        ZStack {
            HStack {
                WebImage(url: card.imageURL)
                    .resizable()
                    .indicator(.activity)
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                VStack {
                    HStack {
                        Text(card.name)
                        Spacer()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 4)
                    
                    HStack {
                        Text(card.classes.joined(separator: " / "))
                        Text("•")
                        Text(card.resultEditions.first?.rarityDescription ?? "")
                            .foregroundStyle(card.resultEditions.first?.rarityColor ?? .gray)
                        if card.isBanned {
                            Text(" BANNED ")
                                .foregroundStyle(.white)
                                .background(.red)
                        }
                        Spacer()
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .textCase(.uppercase)
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }.frame(minHeight: 60)
        }.foregroundStyle(.black)
    }
}

#Preview {
    List(0..<5) { item in
//        CardRowView()
    }
}
