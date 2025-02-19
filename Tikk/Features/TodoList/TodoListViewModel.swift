//
//  TodoListViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

extension TodoListViewModel {
    enum InteractionEvent {
        case addItem(_ item: Todo)
        case createItem
        case commitItem(_ item: Todo)
        case toggleCompleted(_ item: Todo)
    }
}

@Observable class TodoListViewModel {

    var showInputSheet: Bool = false
    var selectedCategory: Category = .all
    var availableCategories: [Category] = [.all, .personal, .work]

    private var items: [Todo] = []
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
        }
    }

    var selectedItems: [Todo] {
        items.filter { _ in selectedCategory == .all } // || $0.category.title == selectedCategory.title } // TODO: Fix comparrison
    }
}

private extension TodoListViewModel {
    func loadItems() {
        Task {
            for await items in todoRepository.fetch() {
                self.items = items
                print("ℹ️ Received list in viewModel: \(items)")
            }
        }
    }

    func onAddItem(_ item: Todo) {
        Task {
            try await todoRepository.add(item)
        }
    }

    func onToggleCompleted(_ todo: Todo) {
        guard let index = items.firstIndex(of: todo) else { return }
        withAnimation {
            items[index].isCompleted.toggle()
        }
        Task {
            try await todoRepository.update(items[index])
        }
    }

    func onCreateItem() {
        showInputSheet = true
    }

    func onCommitItem(_ item: Todo) {
        items.append(item)
        showInputSheet = false

        Task {
            try await todoRepository.add(item)
        }
    }
}
