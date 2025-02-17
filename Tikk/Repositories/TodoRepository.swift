//
//  TodoRepository.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

protocol TodoRepository {
    func fetch() -> [Todo]
    func add(_ todo: Todo) async
    func update(_ todo: Todo) async
}

class TodoRepositoryImp: TodoRepository {

    private let apiService: APIService
    private let databaseService: DatabaseService

    init(apiService: APIService, databaseService: DatabaseService) {
        self.apiService = apiService
        self.databaseService = databaseService
    }

    func fetch() -> [Todo] {
        databaseService.fetchTodos()
    }

    func update(_ todo: Todo) async {
        var cpy = todo
        cpy.lastModified = .now
        cpy.needsSync = true

        databaseService.saveTodo(cpy)
        try? await syncItem(cpy)
    }

    func add(_ todo: Todo) async {
        var cpy = todo
        cpy.lastModified = .now
        cpy.needsSync = true

        databaseService.addTodo(cpy)
        try? await syncItem(cpy)
    }
}

private extension TodoRepositoryImp {

    private func syncWithRemote() async throws {
        let localItems = databaseService.fetchTodos()

        let itemsToSync = localItems.filter(\.needsSync)
        for item in itemsToSync {
            try await syncItem(item)
        }
    }

    private func syncItem(_ item: Todo) async throws {
        try await apiService.updateTodo(item) // MARK: PUT vs POST?
        var cpy = item
        cpy.needsSync = false
        databaseService.saveTodo(cpy)
    }
}
