//
//  View+Hidden.swift
//  Grand Archive Companion
//
//  Created by Tarik Fayad on 1/15/25.
//

import SwiftUI

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        Group {
            if isHidden {
                self.hidden()
            } else {
                self
            }
        }
    }
}
