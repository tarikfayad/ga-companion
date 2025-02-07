//
//  CardDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var card: Card
    
    let maxContentWidth = UIScreen.main.bounds.width - 12
    
    var body: some View {
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
                        SmallBlockHeaderView(title: "Flavor Text")
                        
                        Text(flavor)
                            .padding([.leading, .trailing, .bottom], 10)
                            .padding(.top, 0)
                    }
                    .applyBlockStyling()
                }
                
                VStack(alignment: .leading) {
                    SmallBlockHeaderView(title: "Stats")
                    
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
                            StatBlockView(statName: "Life", statValue: String(life))
                        }
                    }
                }
                .applyBlockStyling()
                
                if let cardEffect = card.effect {
                    VStack(alignment: .leading) {
                        SmallBlockHeaderView(title: "Effect")
                        
                        Text(buildAttributedString(fullText: cardEffect.replacingOccurrences(of: "Class Bonus", with: " Class Bonus "), boldSubstrings: [" Class Bonus ", "On Enter", "On Champion Hit", "On Attack", "Floating Memory", "floating memory", "level", "refinement", "buff", "preparation", "lash", "influence", "gather", "summon", "upkeep", "spellshroud", "Reservable", "reservable", "taunt", "distant", "durability", "Stealth", "stealth", "true sight", "Ranged", "intercept", "Foster", "foster", "On Foster", "vigor", "On Sacrifice", "negate"]))
                            .padding([.leading, .trailing, .bottom], 10)
                            .padding(.top, 0)
                    }
                    .applyBlockStyling()
                }
                
                if let rules = card.rules {
                    VStack(alignment: .leading) {
                        SmallBlockHeaderView(title: "Rules")
                        
                        ForEach(rules, id: \.description) { rule in
                            RuleStackView(rule: rule)
                            HStack {
                                Spacer()
                                Divider()
                                    .frame(width:maxContentWidth - 40, height: 1)
                                    .background(Color.gray)
                                    .opacity(0.25)
                                Spacer()
                            }
                        }
                    }
                    .applyBlockStyling()
                }
                
            }.foregroundStyle(.white)
        }
        .applyBackground()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back
                }) {
                    HStack {
                        Image(systemName: "arrow.backward") // Custom back icon
                    } .foregroundStyle(.white)
                }
            }
        }
    }
    
    func buildAttributedString(fullText: String, boldSubstrings: [String]) -> AttributedString {
        var attributedString = AttributedString(fullText)
        
        for boldSubstring in boldSubstrings {
            do {
                // Create a regex for the substring
                let regex = try NSRegularExpression(
                    pattern: NSRegularExpression.escapedPattern(for: boldSubstring),
                    options: .caseInsensitive
                )
                
                // Find matches
                let matches = regex.matches(
                    in: fullText,
                    options: [],
                    range: NSRange(fullText.startIndex..., in: fullText)
                )
                
                for match in matches {
                    // Convert NSRange to Range<String.Index>
                    if let stringRange = Range(match.range, in: fullText) {
                        // Convert String range to AttributedString range
                        if let attributedRange = Range(stringRange, in: attributedString) {
                            // Apply bold font to the range
                            attributedString[attributedRange].font = Font.system(size: 17, weight: .bold)
                            
                            // Additional check for "Class Bonus"
                            if boldSubstring.lowercased() == " class bonus " {
                                attributedString[attributedRange].backgroundColor = .black
                                attributedString[attributedRange].foregroundColor = .white
                            }
                        }
                    }
                }
            } catch {
                print("Invalid regex pattern: \(error.localizedDescription)")
            }
        }
        
        return attributedString
    }
    
    func buildAttributedStringWithColon(fullText: String, boldSubstring: String) -> AttributedString {
        var attributedString = AttributedString(fullText)
        
        if let range = attributedString.range(of: boldSubstring) {
            attributedString[range].font = .boldSystemFont(ofSize: 17)
            attributedString.insert(AttributedString(": "), at: range.upperBound)
        }
        
        return attributedString
    }
}

#Preview {
//    CardDetailView()
}
