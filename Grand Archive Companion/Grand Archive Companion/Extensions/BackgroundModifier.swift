//
//  BackgroundModifier.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 2/6/25.
//

import SwiftUI

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            content
        }.foregroundStyle(.white)
    }
}
