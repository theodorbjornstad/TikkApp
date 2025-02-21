//
//  AddButton.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct CircularButton: View {
    let imageName: String
    var style: Style
    let size: Size
    let action: () -> Void
    var state: State

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size.imageSize, height: size.imageSize)
                .padding(size.padding)
                .background(style.backgroundColor(state))
                .foregroundColor(style.foregroundColor(state))
                .clipShape(Circle())
        }
        .disabled(state == .disabled)
    }
}

extension CircularButton {
    enum Style {
        case regular
        case desctructive

        func backgroundColor(_ state: State) -> Color {
            switch (self, state) {
            case (.regular, .idle): .blue
            case (.regular, .disabled): .gray.opacity(0.7)
            case (.desctructive, .idle): .red
            case (.desctructive, .disabled): .gray.opacity(0.7)
            }
        }

        func foregroundColor(_ state: State) -> Color {
            switch (self, state) {
            case (.regular, .idle): .white
            case (.regular, .disabled): .white.opacity(0.7)
            case (.desctructive, .idle): .white
            case (.desctructive, .disabled): .white.opacity(0.7)
            }
        }
    }

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

    enum State {
        case idle, disabled
    }
}

#Preview {
    HStack {
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .regular,
            size: .medium,
            action: {},
            state: .idle
        )
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .regular,
            size: .medium,
            action: {},
            state: .disabled
        )
    }
    HStack {
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .desctructive,
            size: .medium,
            action: {},
            state: .idle
        )
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .desctructive,
            size: .medium,
            action: {},
            state: .disabled
        )
    }
    HStack {
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .desctructive,
            size: .small,
            action: {},
            state: .idle
        )
        CircularButton(
            imageName: Asset.Icon.checkmark,
            style: .desctructive,
            size: .small,
            action: {},
            state: .disabled
        )
    }
}
