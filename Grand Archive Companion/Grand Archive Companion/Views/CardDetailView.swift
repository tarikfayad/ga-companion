//
//  CardDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardDetailView: View {
    
    @State var isBanned: Bool = true
    @State var card: Card
    
    let maxContentWidth = UIScreen.main.bounds.width - 12
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            
            ScrollView {
                VStack {
                    WebImage(url: card.imageURL)
                        .resizable()
                        .scaledToFit()
                        .padding([.leading, .trailing] , 5)
                    
                    HStack {
                        if card.isBanned {
                            Text(card.name)
                                .font(.title)
                                .fontWeight(.bold) +
                            Text("   BANNED")
                                .foregroundStyle(.red)
                        } else {
                            Text(card.name)
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(width: maxContentWidth)
                    
                    if let flavor = card.flavorText {
                        VStack(alignment: .leading) {
                            Text("FLAVOR TEXT")
                                .foregroundStyle(.gray)
                                .padding([.top, .leading], 5)
                                .font(.system(size: 13, weight: .medium))
                            
                            Text(flavor)
                                .padding([.leading, .trailing, .bottom], 10)
                                .padding(.top, 0)
                        }
                        .applyBlockStyling()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("STATS")
                            .foregroundStyle(.gray)
                            .padding([.top, .leading], 5)
                            .font(.system(size: 13, weight: .medium))
                        
                        HStack(spacing: 5) {
                            if let memCost = card.memoryCost {
                                StatBlockView(statName: "Memory Cost", statValue: String(memCost))
                            }
                            
                            if let resCost = card.reserveCost {
                                StatBlockView(statName: "Reserve Cost", statValue: String(resCost))
                            }
                            
                            if let power = card.power {
                                StatBlockView(statName: "Power", statValue: String(power))
                            }
                            
                            if let life = card.life {
                                StatBlockView(statName: "Live", statValue: String(life))
                            }
                        }
                    }
                    .applyBlockStyling()
                    
                    if let cardEffect = card.effect {
                        VStack(alignment: .leading) {
                            Text("EFFECT")
                                .foregroundStyle(.gray)
                                .padding([.top, .leading], 5)
                                .font(.system(size: 13, weight: .medium))
                            
                            Text(cardEffect)
                                .padding([.leading, .trailing, .bottom], 10)
                                .padding(.top, 0)
                        }
                        .applyBlockStyling()
                    }
                    
                    if let rules = card.rules {
                        VStack(alignment: .leading) {
                            Text("RULES")
                                .foregroundStyle(.gray)
                                .padding([.top, .leading], 5)
                                .font(.system(size: 13, weight: .medium))
                            
                            ForEach(rules, id: \.description) { rule in
                                RuleStackView(rule: rule)
                                HStack {
                                    Spacer()
                                    Divider()
                                        .frame(width:maxContentWidth - 40, height: 1)
                                        .background(Color.gray)
                                        .opacity(0.25)
                                    Spacer()
                                } // Set color
                            }
                        }
                        .applyBlockStyling()
                    }
                    
                }.foregroundStyle(.white)
            }
        }
    }
}

#Preview {
//    CardDetailView()
}
