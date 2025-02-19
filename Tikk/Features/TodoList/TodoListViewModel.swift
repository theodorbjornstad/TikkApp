//
//  TodoListViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import GRDB
import SwiftUI

extension TodoListViewModel {
    enum InteractionEvent {
        case refresh
        case addItem(_ item: Todo)
        case editItem(_ item: Todo)
        case createItem
        case commitItem(_ item: Todo)
        case toggleCompleted(_ item: Todo)
    }
}

@Observable class TodoListViewModel {

    var showInputSheet: Todo?
    var items: [Todo] = []
    private let todoRepository: TodoRepository

    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
        loadItems()
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .addItem(let item): onAddItem(item)
        case .createItem:
            onCreateItem()
        case .toggleCompleted(let item):
            onToggleCompleted(item)
        case .commitItem(let item):
            onCommitItem(item)
        case .refresh:
            onRefresh()
        case .editItem(let item):
            onEditItem(item)
        }
    }
}

private extension TodoListViewModel {
    func loadItems() {
        Task {
            for await items in todoRepository.fetch() {
                self.items = items
            }
            print("ℹ️ Received list in viewModel: \(items)")
        }
    }

    func onAddItem(_ item: Todo) {
        Task {
            try await todoRepository.save(item)
        }
    }

    func onToggleCompleted(_ todo: Todo) {
        guard let index = items.firstIndex(of: todo) else { return }
        withAnimation {
            items[index].isCompleted.toggle()
        }
        Task {
            try await todoRepository.save(items[index])
        }
    }

    func onRefresh() {
        Task {
            try await todoRepository.sync()
            items = try todoRepository.fetch()
        }
    }

    func onCreateItem() {
        showInputSheet = .init(
            id: nil,
            remoteId: nil,
            title: "",
            isCompleted: false,
            syncStatus: .pending,
            lastModified: .now
        )
    }

    func onCommitItem(_ item: Todo) {
        items.append(item)
        showInputSheet = nil

        Task {
            try await todoRepository.save(item)
        }
    }

    func onEditItem(_ item: Todo) {
        showInputSheet = item
    }
}
