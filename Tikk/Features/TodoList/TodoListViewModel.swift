//
//  TodoListViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import Combine

extension TodoListViewModel {
    enum InteractionEvent {
        case addItem(_ item: Todo)
        case editItem(_ item: Todo)
        case createItem
        case commitItem(_ item: Todo)
        case toggleCompleted(_ item: Todo)
    }
}

class TodoListViewModel<DS: DataService>: ObservableObject where DS.Item == Todo {

    @Published var showInputSheet: Todo?
    @Published var items: [Todo] = []
    @Published private var isOnline: Bool = true
    private let dataService: DS
    private let networkMonitor: NetworkMonitorService
    private var cancellables: Set<AnyCancellable>

    init(
        dataService: DS,
        networkMonitor: NetworkMonitorService
    ) {
        self.dataService = dataService
        self.networkMonitor = networkMonitor
        self.cancellables = Set<AnyCancellable>()
        self.setObservers()
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
        case .editItem(let item):
            onEditItem(item)
        }
    }
}

// MARK: View State

extension TodoListViewModel {
    var toolbarIcon: String {
        isOnline ? Asset.Icon.online : Asset.Icon.offline
    }
}

// MARK: Private functions - View Actions

private extension TodoListViewModel {

    func onAddItem(_ item: Todo) {
        dataService.add(item)
    }

    func onToggleCompleted(_ todo: Todo) {
        var copy = todo
        copy.completed.toggle()
        dataService.update(copy)
    }

    func onCreateItem() {
        showInputSheet = .init(title: "", completed: false, lastModified: .now)
    }

    func onCommitItem(_ item: Todo) {
        showInputSheet = nil

        if items.contains(where: { $0.id == item.id }) {
            dataService.update(item)
        } else {
            dataService.add(item)
        }
    }

    func onEditItem(_ item: Todo) {
        showInputSheet = item
    }
}

// MARK: Private functions

private extension TodoListViewModel {
    func setObservers() {
        // Observe todo items
        dataService
            .getData()
            .sink { error in
                // TODO: Handle error
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)

        // Observe network status
        networkMonitor.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.isOnline = status
            }
            .store(in: &cancellables)
    }
}
