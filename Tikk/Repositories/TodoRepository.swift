//
//  TodoRepository.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

protocol TodoRepository {
    func fetch() -> AsyncStream<[Todo]>
    func fetch() throws -> [Todo]
    func save(_ todo: Todo) async throws
    func sync() async throws
}

class TodoRepositoryImp: TodoRepository {

    private let apiService: APIService
    private let databaseService: DatabaseService

    init(apiService: APIService, databaseService: DatabaseService) {
        self.apiService = apiService
        self.databaseService = databaseService
    }

    func fetch() -> AsyncStream<[Todo]> {
        AsyncStream { stream in
            Task {
                defer { stream.finish() }
                do {
                    let localTodos = try databaseService.fetchTodos()
                    stream.yield(localTodos)
                    try await sync()
                    let updatedTodos = try databaseService.fetchTodos()
                    stream.yield(updatedTodos)
                } catch {
                    print("❌ Error fetching todos: \(error)")
                }
            }
        }
    }

    func fetch() throws -> [Todo] {
        try databaseService.fetchTodos()
    }

    func save(_ todo: Todo) async throws {
        var cpy = todo
        cpy.lastModified = .now
        cpy.syncStatus = .pending
        try databaseService.saveTodo(cpy)
    }

    func sync() async throws {
        print("🔄 Triggering sync...")
        await pullServerChanges()
        await pushPendingTodos()
    }
}

private extension TodoRepositoryImp {

    private func pullServerChanges() async {
        do {
            let lastSyncTimestamp = databaseService.fetchLastSync()
            let serverTodos = try await apiService.fetchTodos(lastSyncTimestamp: lastSyncTimestamp)
            let localTodos = try databaseService.fetchTodos()

            for serverTodo in serverTodos {
                if let localTodo = localTodos.first(where: { $0.remoteId == serverTodo.remoteId }) {
                    // Conflict resolution: last write wins
                    print("🔀 serverTodo: \(serverTodo.lastModified)  localTodo: \(localTodo.lastModified)")
                    if serverTodo.lastModified > localTodo.lastModified {
                        var syncedTodo = serverTodo
                        syncedTodo.id = localTodo.id
                        syncedTodo.syncStatus = .synced
                        print("🔀 Inserting todo from server after conflict resolution")
                        try databaseService.saveTodo(syncedTodo)
                    }
                } else {
                    print("⬇️ Inserting todo from server")
                    try databaseService.saveTodo(serverTodo)
                }
            }
        } catch {
            print("❌ Error during merging local and server data: \(error)")
        }
    }

    func pushPendingTodos() async {
        do {
            let pendingTodos = try databaseService.fetchPendingTodos()

            for todo in pendingTodos {
                print("⬆️ Pushing pending todo to server: \(todo)")

                var syncedTodo = todo
                if syncedTodo.remoteId == nil {
                    let remoteId = try await apiService.addTodo(todo)
                    syncedTodo.remoteId = remoteId
                } else {
                    try await apiService.saveTodo(todo)
                }
                syncedTodo.syncStatus = .synced
                try databaseService.saveTodo(syncedTodo)
            }
        } catch {
            print("❌ Error syncing pending todos to Firestore: \(error)")
        }
    }
}
