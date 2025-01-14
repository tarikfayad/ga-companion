//
//  ContentView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack {
                Text("Grand Archive Companion")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                    Text("New Game")
                }.padding()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                    Text("Card Search")
                }.padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
