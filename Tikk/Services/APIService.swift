//
//  APIService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 14/02/2025.
//

import SwiftUI

protocol APIService {
    func fetchTodos() async throws -> [Todo]
    func deleteTodo(_ todo: Todo) async throws
    func updateTodo(_ todo: Todo) async throws
    func addTodo(_ todo: Todo) async throws
}

class APIServiceImp: APIService {

    func fetchTodos() async -> [Todo] {
        print("Fetching tasks from remote...")
        return []
    }

    func deleteTodo(_ todo: Todo) async throws {
        print("Deleting todo with title: \(todo.title) from remote...")
    }

    func updateTodo(_ todo: Todo) {
        print("Updating todo with title: \(todo.title) in remote...")
    }

    func addTodo(_ todo: Todo) async throws {
        print("Adding todo with title: \(todo.title) in remote...")
    }
}
