//
//  TodoDetailViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

extension TodoDetailViewModel {
    enum InteractionEvent {
        case save
        case delete
    }
    enum Action: AutoIdentifiable {
        case add
        case edit(Todo)
    }
}

@MainActor class TodoDetailViewModel: ObservableObject {

    @Injected(\.dataService) private var dataService
    @Published var selectedText: String

    private var item: Todo
    private let action: Action
    private let onCommit: () -> Void

    init(action: Action, onCommit: @escaping () -> Void) {
        self.onCommit = onCommit
        self.action = action

        switch action {
        case .add:
            item = .init(title: "", completed: false)
            selectedText = ""
        case .edit(let todo):
            item = todo
            selectedText = todo.title
        }
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .save: onSave()
        case .delete: onDelete()
        }
    }
}

// MARK: View State

extension TodoDetailViewModel {

    var placeholder: String { Asset.String.input_placeholder }

    var saveButtonState: CircularButton.State {
        selectedText.isEmpty || selectedText == item.title ? .disabled : .idle
    }

    var showDeleteButton: Bool {
        switch action {
        case .add: false
        case .edit: true
        }
    }
}

// MARK: Private functions

extension TodoDetailViewModel {
    func onDelete() {
        guard case .edit(let todo) = action else {
            return
        }
        dataService.delete(todo)
        onCommit()
    }

    func onSave() {
        item.title = selectedText

        switch action {
        case .add:
            dataService.add(item)
        case .edit:
            dataService.update(item)
        }
        onCommit()
    }
}
