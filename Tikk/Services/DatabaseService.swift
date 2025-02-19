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
    func fetchPendingTodos() throws -> [Todo]
	func saveTodo(_ todo: Todo) throws
    func fetchLastSync() -> Date
    func setLastSync()
}

struct DatabaseServiceImp: DatabaseService {

    let databaseClient: GRDBClient
    let lastSyncKey = "lastSyncTimestamp"

    init(databaseClient: GRDBClient) {
        self.databaseClient = databaseClient
    }

    func fetchTodos() throws -> [Todo] {
        try databaseClient.reader.read { db in
            try Todo.fetchAll(db)
        }
    }

    func fetchPendingTodos() throws -> [Todo] {
        try databaseClient.reader.read { db in
            try Todo
                .filter(Column("syncStatus") == SyncStatus.pending.rawValue)
                .fetchAll(db)
        }
    }

    func saveTodo(_ todo: Todo) throws {
        print("💾 Saving todo: \(todo)")
        var copy = todo
        try databaseClient.writer.write { db in
            try copy.upsert(db)
        }
    }

    func fetchLastSync() -> Date {
        if let date = UserDefaults.standard.object(forKey: lastSyncKey) as? Date {
            return date
        }
        return Date(timeIntervalSince1970: 0)
    }

    func setLastSync() {
        UserDefaults.standard.set(Date(), forKey: lastSyncKey)
    }
}
