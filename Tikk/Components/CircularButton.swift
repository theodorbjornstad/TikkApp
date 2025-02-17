//
//  AddButton.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI


extension CircularButton {
    enum Size {
        case small
        case medium

        var imageSize: CGFloat {
            switch self {
            case .small: 18
            case .medium: 36
            }
        }

        var padding: CGFloat {
            switch self {
            case .small: 16
            case .medium: 24
            }
        }
    }
}

struct CircularButton: View {
    let imageName: String
    let size: CircularButton.Size
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size.imageSize, height: size.imageSize)
                .padding(size.padding)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}
