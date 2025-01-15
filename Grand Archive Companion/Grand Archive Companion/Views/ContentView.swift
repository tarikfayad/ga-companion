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
            Color.background.ignoresSafeArea(.all)
            
            VStack {
                Text("Grand Archive Companion")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Button {
                    
                } label: {
                    Text("Start")
                        .frame(width:270, height:27)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                    Text("Card Search")
                }
                .padding()
                .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    ContentView()
}
