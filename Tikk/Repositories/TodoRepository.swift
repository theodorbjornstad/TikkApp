//
//  TodoRepository.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

protocol TodoRepository {
    func fetch() -> AsyncStream<[Todo]>
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

    func fetch() -> AsyncStream<[Todo]> {
        AsyncStream { continuation in
            Task {
                let localTodos = databaseService.fetchTodos()
                continuation.yield(localTodos)

                await syncWithRemote()

                if let remoteTodos = try? await fetchFromRemoteAndUpdateLocal() {
                    continuation.yield(remoteTodos)
                }
                continuation.finish()
            }
        }
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

    func fetchFromRemoteAndUpdateLocal() async throws -> [Todo] {
        let remoteList = try await apiService.fetchTodos()
        let localList = databaseService.fetchTodos()
        let mergedList = merge(localList: localList, remoteList: remoteList)
        databaseService.overwrite(mergedList)
        return mergedList
    }

    func resolveConflict(local: Todo, remote: Todo) -> Todo {
        if local.lastModified > remote.lastModified {
            return local
        } else {
            return remote
        }
    }

    func merge(localList: [Todo], remoteList: [Todo]) -> [Todo] {
        var todoMap = Dictionary(uniqueKeysWithValues: localList.map { ($0.id, $0) })

        for remoteItem in remoteList {
            if let localItem = todoMap[remoteItem.id] {
                todoMap[remoteItem.id] = resolveConflict(local: localItem, remote: remoteItem)
            } else {
                todoMap[remoteItem.id] = remoteItem
            }
        }
        return Array(todoMap.values)
    }

    func syncWithRemote() async {
        let itemsToSync = databaseService
            .fetchTodos()
            .filter(\.needsSync)

        // Perform sync in parallel
         await withTaskGroup(of: Void.self) { group in
             for item in itemsToSync {
                 group.addTask {
                     do {
                         try await self.syncItem(item)
                     } catch {
                         print("⚠️ Failed to sync item \(item.id): \(error)")
                     }
                 }
             }
         }
    }

    func syncItem(_ item: Todo) async throws {
        try await apiService.updateTodo(item) // MARK: PUT vs POST?
        var cpy = item
        cpy.needsSync = false
        databaseService.saveTodo(cpy)
    }
}
