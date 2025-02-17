//
//  TodoDetailViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

extension TodoDetailViewModel {
    enum InteractionEvent {
        case commit
    }
}

@Observable
class TodoDetailViewModel {

    let placeholder: String = Asset.String.input_placeholder
    let availableCategories: [Category] = [.none, .personal, .work]

    var selectedText: String = ""
    var selectedCategory: Category

    private let onCommit: (Todo) -> Void

    init(onCommit: @escaping (Todo) -> Void) {
        self.onCommit = onCommit
        self.selectedText = ""
        self.selectedCategory = .none
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .commit:
            onCommit(.init(
                title: selectedText,
                category: selectedCategory
            ))
        }
    }
}
