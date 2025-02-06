//
//  LineageWinRateView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI

struct LineageWinRateView: View {
    var champion: Champion
    var winRate: Double
    var imageSize: CGFloat = 100
    var isSelected: Bool = false
    let onTap: (Champion) -> Void
    
    var body: some View {
        ZStack {
            Image(champion.imageName())
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(imageSize / 2)
                .overlay(Circle().stroke(isSelected ? .playerYellow : .white, lineWidth: 2))
            
            Text(String(format: "%.0f%%", winRate))
                .font(.system(size: 10))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(
                    Circle()
                        .fill(.playerPink)
                        .frame(width: imageSize/2, height: imageSize/2)
                        .overlay(Circle().stroke(isSelected ? .playerYellow : .white, lineWidth: 2))
                )
                .padding(.top, imageSize - 10)
        }.onTapGesture{
            onTap(champion)
        }
    }
}

#Preview {
    let playerChampion = Champion.init(name: "Lorraine, Crux Knight", lineage: "Lorraine", jobs: ["Warrior"], health: 28, level: 3)
    
    LineageWinRateView(champion: playerChampion, winRate: 50.54, isSelected: false){ champion in}
}
