//
//  CategoryTag.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct Tag: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.caption)
            .bold()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
