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
    var selectedText: String = ""

    private var item: Todo
    private let onCommit: (Todo) -> Void

    init(item: Todo, onCommit: @escaping (Todo) -> Void) {
        self.onCommit = onCommit
        self.item = item
        selectedText = item.title
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .commit:
            item.title = selectedText
            item.lastModified = .now
            onCommit(item)
        }
    }
}
