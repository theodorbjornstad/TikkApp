//
//  AddButton.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

enum ButtonSize {

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

struct CircularButton: View {
    let imageName: String
    let size: ButtonSize
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

#Preview {
    CircularButton(imageName: Asset.Icon.plus, size: .medium, action: {})
    CircularButton(imageName: Asset.Icon.checkmark, size: .small, action: {})
}
