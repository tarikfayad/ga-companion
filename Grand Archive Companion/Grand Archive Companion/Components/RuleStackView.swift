//
//  RuleStackView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/17/25.
//

import SwiftUI

struct RuleStackView: View {
    
    @State var rule: Rule
    
    var body: some View {
        
        if !rule.title.isEmpty {
            Text(rule.title)
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 0)
                .textCase(.uppercase)
        }
        
        Text(rule.dateAdded)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 0)
            .font(.system(size: 12))
        
        Text(rule.description.replacingOccurrences(of: "\n", with: "\n\n"))
            .padding([.leading, .trailing, .bottom], 10)
            .padding(.top, 0)
    }
}

#Preview {
    let rule = Rule(title: "Test Rule", dateAdded: "10/9/2024", description: "A durability counter is removed on the resolution of the damage step. Before the On Kill ability of Executioner's Spear resolves, the weapon is checked for destruction due to zero durability counters.")
    RuleStackView(rule:rule)
}
