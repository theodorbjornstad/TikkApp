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
        case closeSheet
        case toggleCompleted(_ item: Todo)
    }
}

class TodoListViewModel: ObservableObject {

    @Injected(\.todoRepository) private var todoRepository
    @Injected(\.networkMonitorService) private var networkMonitorService

    @Published var sheetAction: TodoDetailViewModel.Action?
    @Published var items: [Todo] = []

    @Published private var isOnline: Bool = true
    private var cancellables: Set<AnyCancellable>

    init() {
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
        case .closeSheet:
            onCloseSheet()
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
        performAction(todoRepository.add(item))
    }

    func onToggleCompleted(_ todo: Todo) {
        var copy = todo
        copy.completed.toggle()
        performAction(todoRepository.update(copy))
    }

    func onCreateItem() {
        sheetAction = .add
    }

    func onCloseSheet() {
        sheetAction = nil
    }

    func onEditItem(_ item: Todo) {
        sheetAction = .edit(item)
    }
}

extension TodoListViewModel {

    private func setObservers() {
        // Observe todo items
        performAction(todoRepository.getData()) { [weak self] todos in
            self?.items = todos
        }

        // Observe network status
        networkMonitorService.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                withAnimation {
                    self?.isOnline = status
                }
            }
            .store(in: &cancellables)
    }

    private func performAction<T>(
        _ publisher: AnyPublisher<T, Error>,
        successHandler: ((T) -> Void)? = nil,
        failureHandler: ((Error) -> Void)? = nil
    ) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    guard let self else { return }

                    // let errorMessage = self.firebaseErrorMessage(from: error)
                    // self.modelError = TodoListModelError(message: errorMessage)

                    failureHandler?(error)
                case .finished: break
                }
            } receiveValue: { value in
                successHandler?(value)
            }
            .store(in: &cancellables)
    }
}
