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
        case markCompleted(_ item: Todo)
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
        case .markCompleted(let item):
            onMarkCompleted(item)
        case .commitItem(let item):
            onCommitItem(item)
        }
    }

    var selectedItems: [Todo] {
        items.filter { selectedCategory == .all || $0.category == selectedCategory }
    }
}

private extension TodoListViewModel {
    func loadItems() {
        Task {
            self.items = todoRepository.fetch()
        }
    }

    func onAddItem(_ item: Todo) {
        Task {
            await todoRepository.add(item)
        }
    }

    func onMarkCompleted(_ todo: Todo) {
        withAnimation {
            guard let index = items.firstIndex(of: todo) else { return }
            items[index].isCompleted.toggle()
        }
        Task {
            await todoRepository.update(todo)
        }
    }

    func onCreateItem() {
        showInputSheet = true
    }

    func onCommitItem(_ item: Todo) {
        items.append(item)
        showInputSheet = false

        Task {
            await todoRepository.add(item)
        }
    }
}
