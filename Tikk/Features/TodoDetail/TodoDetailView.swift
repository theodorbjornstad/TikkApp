//
//  TodoDetailView.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

struct TodoDetailView: View {
    init(onCommit: @escaping (Todo) -> Void) {
        self._viewModel = State(wrappedValue: TodoDetailViewModel(onCommit: onCommit))
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
            picker
            Spacer()

            // TODO: Add state
            CircularButton(
                imageName: Asset.Icon.checkmark,
                size: .small,
                action: { viewModel.handleEvent(.commit) }
            )
        }
    }

    var picker: some View {
        Menu {
            Picker(
                selection: $viewModel.selectedCategory,
                label: EmptyView(),
                content: {
                    ForEach(viewModel.availableCategories, id: \.id) {
                        Text($0.title)
                            .tag($0)
                    }
                }
            )
            .pickerStyle(.automatic)
        } label: {
            Tag(
                title: viewModel.selectedCategory.title,
                color: viewModel.selectedCategory.color
            )
        }
    }
}

#Preview {
    TodoDetailView(onCommit: { _ in })
}
