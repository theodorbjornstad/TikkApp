//
//  TodoDetailView.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import Observation
import SwiftUI

struct TodoDetailView: View {

    @StateObject var viewModel: TodoDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                textInput
                footer
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
        }
        .scrollIndicators(.hidden)
    }

    var textInput: some View {
        TextField(viewModel.placeholder, text: $viewModel.selectedText)
            .frame(minHeight: 24)
    }

    var footer: some View {
        HStack {
            Spacer()

            CircularButton(
                imageName: Asset.Icon.checkmark,
                style: .regular,
                size: .small,
                action: { viewModel.handleEvent(.save) },
                state: viewModel.saveButtonState
            )
            if viewModel.showDeleteButton {
                CircularButton(
                    imageName: Asset.Icon.delete,
                    style: .desctructive,
                    size: .small,
                    action: { viewModel.handleEvent(.delete) },
                    state: .idle
                )
            }
        }
    }
}
