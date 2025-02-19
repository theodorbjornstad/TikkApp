//
//  DatabaseService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import GRDB

protocol DatabaseService {
    func fetchTodos() throws -> [Todo]
    func addTodo(_ todo: Todo) throws
	func saveTodo(_ todo: Todo) throws
    func overwrite(_ todos: [Todo]) throws
}

struct DatabaseServiceImp: DatabaseService {

    let databaseClient: GRDBClient

    init(databaseClient: GRDBClient) {
        self.databaseClient = databaseClient
    }


    func fetchTodos() throws -> [Todo] {
        try databaseClient.reader.read { db in
            try Todo.fetchAll(db)
        }
    }

    func addTodo(_ todo: Todo) throws {
        try databaseClient.writer.write { db in
            try todo.insert(db)
        }
    }

    func saveTodo(_ todo: Todo) throws {
        try databaseClient.writer.write { db in
            try todo.update(db)
        }
    }

    func deleteTodo(_ todo: Todo) throws {
        try databaseClient.writer.write { db in
            _ = try todo.delete(db)
        }
    }

    func overwrite(_ todos: [Todo]) throws {
        try databaseClient.writer.write { db in
            _ = try Todo.deleteAll(db)
            try todos.forEach { todo in
                try todo.insert(db)
            }
        }
    }
}

extension [Todo] {
    static let dummy: Self = [
        // .init(title: "UI Design", category: .work, isCompleted: false, needsSync: true, lastModified: .now) // ,
        // .init(title: "Web Development", category: .personal),
        // .init(title: "Office Meeting", category: .work)
    ]
}
