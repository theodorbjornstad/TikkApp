//
//  Pill.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

struct Pill: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Asset.Color.primary : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Asset.Color.primary : Color.clear, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
