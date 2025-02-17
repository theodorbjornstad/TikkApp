//
//  ColorAsset.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

enum Asset {
    enum Color {
        static let textPrimary = SwiftUI.Color.black
        static let textSecondary = SwiftUI.Color.gray

        static let primary = SwiftUI.Color.blue
        static let background = SwiftUI.Color.gray.opacity(0.2)
        static let surface = SwiftUI.Color.white
    }
    enum Animation {
        static let splashScreen = "animation_splash"
        static let emptyState = "animation_empty"
    }
    enum Icon {
        static let plus = "plus"
        static let checkmark = "checkmark"
    }
}
