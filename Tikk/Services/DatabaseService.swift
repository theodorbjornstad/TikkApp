//
//  DatabaseService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import SwiftData

protocol DatabaseService {
    func fetchTodos() -> [Todo]
    func addTodo(_ todo: Todo)
	func saveTodo(_ todo: Todo)
    func overwrite(_ todos: [Todo])
}

class DatabaseServiceImp: DatabaseService {

    // MARK: This is database data
    var todos: [Todo] = .dummy

    func fetchTodos() -> [Todo] {
        return todos
    }

    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }

    func saveTodo(_ todo: Todo) {
        // TODO: Implement actual db - this is only temporary
        print("[DatabaseService] updating todo with title: \(todo.title) isCompleted: \(todo.isCompleted) needsSync: \(todo.needsSync)")
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }

    func overwrite(_ todos: [Todo]) {
        self.todos = todos
    }
}

extension [Todo] {
    static let dummy: Self = [
        .init(title: "UI Design", category: .work),
        .init(title: "Web Development", category: .personal),
        .init(title: "Office Meeting", category: .work)
    ]
}
