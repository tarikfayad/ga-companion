//
//  MatchRowView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/28/25.
//

import SwiftUI

struct MatchRowView: View {
    @State var match: Match
    let imageSize: CGFloat = 45
    let imageStrokeColor: Color = .white
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack {
                    ZStack {
                        Image(match.userDeck.champion.imageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize + 10, height: imageSize + 10)
                            .cornerRadius(imageSize / 2)
                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 3))
                        
                        VStack {
                            Spacer()
                            HStack {
                                ForEach(match.userDeck.elements, id: \.self){ element in
                                    Image(element.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: imageSize / 2, height: imageSize / 2)
                                        .cornerRadius(imageSize / 4)
                                        .overlay(Circle().stroke(imageStrokeColor, lineWidth: 3))
                                }
                            }
                        }
                    }
                }.frame(minWidth: 100)
                
                Text("vs")
                
                HStack {
                    ZStack {
                        Image(match.opponentDeck.champion.imageName())
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageSize + 10, height: imageSize + 10)
                            .cornerRadius(imageSize / 2)
                            .overlay(Circle().stroke(imageStrokeColor, lineWidth: 3))
                        
                        VStack {
                            Spacer()
                            HStack {
                                ForEach(match.opponentDeck.elements, id: \.self){ element in
                                    Image(element.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: imageSize / 2, height: imageSize / 2)
                                        .cornerRadius(imageSize / 4)
                                        .overlay(Circle().stroke(imageStrokeColor, lineWidth: 3))
                                }
                            }
                        }
                    }
                }.frame(minWidth: 100)
                Spacer()
            }
            HStack {
                Spacer()
                Text(match.didUserWin ? "WIN" : "LOSE")
                    .foregroundStyle(match.didUserWin ? .green : .red)
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
}

#Preview {
//    List(0..<5) { item in
//        MatchRowView()
//            .background(Color.background)
//    }
}
