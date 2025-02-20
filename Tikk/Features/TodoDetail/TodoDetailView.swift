//
//  TodoDetailView.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

struct TodoDetailView: View {
    init(item: Todo, onCommit: @escaping (Todo) -> Void) {
        self._viewModel = State(
            wrappedValue: TodoDetailViewModel(
                item: item,
                onCommit: onCommit
            )
        )
    }

    @State var viewModel: TodoDetailViewModel

    var body: some View {
        VStack(spacing: 16) {
            textInput
            footer
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }

    var textInput: some View {
        TextField(viewModel.placeholder, text: $viewModel.selectedText)
    }

    var footer: some View {
        HStack {
            Spacer()

            // TODO: Add state
            CircularButton(
                imageName: Asset.Icon.checkmark,
                size: .small,
                action: { viewModel.handleEvent(.commit) }
            )
        }
    }
}
