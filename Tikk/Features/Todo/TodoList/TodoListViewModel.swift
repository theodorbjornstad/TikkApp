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
        case createItem
        case editItem(Todo)
        case toggleCompleted(Todo)
    }
    enum SheetInteractionEvent {
        case save(Todo)
        case delete(Todo)
    }
}

class TodoListViewModel: ObservableObject {
    @Injected(\.todoRepository) private var todoRepository
    @Injected(\.networkMonitorService) private var networkMonitorService

    @Published var useCase: TodoDetailViewModel.UseCase?
    @Published var items: [Todo] = []
    @Published var error: ListError?
    @Published private var isOnline: Bool = true

    private var cancellables = Set<AnyCancellable>()

    init() {
        observeData()
        observeNetworkStatus()
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .createItem:
            useCase = .add
        case .editItem(let item):
            useCase = .edit(item)
        case .toggleCompleted(let item):
            toggleCompletion(for: item)
        }
    }

    func handleSheetEvent(_ event: SheetInteractionEvent) {
        guard let useCase else { return }
        self.useCase = nil

        switch event {
        case .save(let item):
            let action = (useCase == .add) ? todoRepository.add(item) : todoRepository.update(item)
            performAction(action)
        case .delete(let item):
            performAction(todoRepository.delete(item))
        }
    }

    var toolbarIcon: String {
        isOnline ? Asset.Icon.online : Asset.Icon.offline
    }

    struct ListError: Identifiable {
        let id = UUID()
        let title = "Error"
        let message: String
        let dismissButtonTitle: String = "Ok"
    }
}

// MARK: Private functions

private extension TodoListViewModel {

    func toggleCompletion(for todo: Todo) {
        var updatedTodo = todo
        updatedTodo.completed.toggle()
        performAction(todoRepository.update(updatedTodo))
    }

    func observeData() {
        performAction(todoRepository.getData()) { [weak self] todos in
            self?.items = todos
        }
    }

    func observeNetworkStatus() {
        networkMonitorService.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                withAnimation { self?.isOnline = status }
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
                    self.error = ListError(message: error.message)
                    failureHandler?(error)
                case .finished: break
                }
            } receiveValue: { value in
                successHandler?(value)
            }
            .store(in: &cancellables)
    }
}


private extension Error {
    var message: String {
        if let firebaseError = self as? FirebaseDataServiceError {
            return switch firebaseError {
            case .documentIDMissing: "The document does not have a valid ID."
            case .addDocumentFailed: "Error adding the document."
            case .deleteDocumentFailed: "Error deleting the document."
            case .updateDocumentFailed: "Error updating the document."
            }
        } else {
            return self.localizedDescription
        }
    }
}
