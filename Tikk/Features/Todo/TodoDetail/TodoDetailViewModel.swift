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

    enum UseCase: AutoIdentifiable {
        case add
        case edit(Todo)

        var initialTitle: String {
            switch self {
            case .add: return ""
            case .edit(let todo): return todo.title
            }
        }

        var existingItem: Todo? {
            switch self {
            case .add: return nil
            case .edit(let todo): return todo
            }
        }
    }
}

@MainActor
class TodoDetailViewModel: ObservableObject {
    @Published var title: String

    private let useCase: UseCase
    private let onDelete: (Todo) -> Void
    private let onSave: (Todo) -> Void

    init(
        useCase: UseCase,
        onDelete: @escaping (Todo) -> Void,
        onSave: @escaping (Todo) -> Void
    ) {
        self.useCase = useCase
        self.onDelete = onDelete
        self.onSave = onSave
        self.title = useCase.initialTitle
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .save:
            let todo = useCase.existingItem?.withUpdatedTitle(title) ?? Todo(title: title, completed: false)
            onSave(todo)
        case .delete:
            if let todo = useCase.existingItem {
                onDelete(todo)
            }
        }
    }
}

// MARK: - View State

extension TodoDetailViewModel {
    var saveButtonState: CircularButton.State {
        title.isEmpty || title == useCase.initialTitle ? .disabled : .idle
    }

    var showDeleteButton: Bool {
        useCase.existingItem != nil
    }
}

// MARK: - Helper

private extension Todo {
    func withUpdatedTitle(_ newTitle: String) -> Todo {
        Todo(id: id, title: newTitle, completed: completed)
    }
}
