//
//  CardPageView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardPageView: View {
    @State private var currentPage = 0
    
    var cards: [Card] = []
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(cards, id: \.uuid) { card in
                    WebImage(url: card.imageURL) { image in
                        image.resizable()
                            .scaledToFit()
                            .padding([.leading, .trailing] , 5)
                            .ignoresSafeArea()
                    } placeholder: {
                        Image("card_back")
                            .resizable()
                            .scaledToFit()
                            .padding([.leading, .trailing] , 5)
                            .ignoresSafeArea()
                    }.tag(cards.firstIndex(of: card) ?? 0)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CardPageControl(currentPage: currentPage, numberOfPages: cards.count)
                    .frame(height: 30)
            }
        }
    }
}

struct CardPageControl: UIViewRepresentable {
    var currentPage: Int
    var numberOfPages: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        pageControl.backgroundStyle = .prominent
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}

#Preview {
    CardPageView()
}
