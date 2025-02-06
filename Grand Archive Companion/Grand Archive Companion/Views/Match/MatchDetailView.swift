//
//  MatchDetailView.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/6/25.
//

import SwiftUI

struct MatchDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
        }.applyBackground()
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
            
            ToolbarItem(placement: .principal) {
                Text("Match Details")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    NavigationStack {
        MatchDetailView()
    }
}
