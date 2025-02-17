//
//  TodoCell.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct ListRow: View {

    let title: String
    let category: Category
    var isChecked: Bool
    let onCheck: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            radioButton
            titleItem
            Spacer()

            if category != .none {
                Tag(title: category.title, color: category.color)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Asset.Color.surface)
        .cornerRadius(15)
        .shadow(color: isChecked ? Color.black.opacity(0.1) : Color.clear, radius: 5, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.3), value: isChecked)
    }

    private var radioButton: some View {
        RadioButton(isChecked: isChecked)
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                    onCheck()
                }
            }
    }

    private var titleItem: some View {
        Text(title)
            .strikethrough(isChecked, color: Asset.Color.textSecondary)
            .foregroundColor(isChecked ? Asset.Color.textSecondary : Asset.Color.textPrimary)
            .opacity(isChecked ? 0.5 : 1)
            .scaleEffect(isChecked ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.3), value: isChecked)
    }
}


#Preview {
    @Previewable @State var todo = [Todo].dummy.first!

    ListRow(
        title: todo.title,
        category: todo.category,
        isChecked: todo.isCompleted,
        onCheck: {}
    )
    .padding()
}
