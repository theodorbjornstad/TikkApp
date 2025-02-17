//
//  RadioButton.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct RadioButton: View {

    let isChecked: Bool

    var body: some View {
        ZStack {
            borderedContainer

            if isChecked {
                checkMark
            }
        }
        .contentShape(Rectangle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isChecked)
    }

    private var borderedContainer: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(isChecked ? Color.blue : Color.clear)
            .frame(width: 24, height: 24)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 2)
            )
    }

    private var checkMark: some View {
        Image(systemName: Asset.Icon.checkmark)
            .font(.system(size: 14, weight: .heavy))
            .foregroundColor(.white)
            .transition(.scale)
    }
}

#Preview {
    TodoListView(
        apiService: APIServiceImp(),
        databaseService: DatabaseServiceImp()
    )
}
