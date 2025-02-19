//
//  GRDBClient.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 19/02/2025.
//

import Foundation
import GRDB

struct GRDBClient {
    let writer: DatabaseWriter

    init(_ writer: DatabaseWriter) throws {
        self.writer = writer
        try migrator.migrate(writer)
    }

    var reader: DatabaseReader {
        writer
    }
}


// MARK: Persistent

extension GRDBClient {
    static let persistent: GRDBClient = {
        do {
            let fileManager = FileManager()
            let folder = try fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("database", isDirectory: true)
            if CommandLine.arguments.contains("-reset") {
                try? fileManager.removeItem(at: folder)
            }
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
            let url = folder.appendingPathComponent("db.sqlite")
            var config = Configuration()
            #if DEBUG
            config.prepareDatabase { db in
                db.trace { print($0.expandedDescription) }
            }
            #endif
            let writer = try DatabasePool(path: url.path, configuration: config)
            let database = try GRDBClient(writer)
            return database
        } catch {
            fatalError("Unresolved error: \(error)")
        }
    }()
}


// MARK: Migrator

extension GRDBClient {
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        migrator.registerMigration("v1") { db in
            try createTodoTable(db)
        }
        return migrator
    }

    private func createTodoTable(_ db: GRDB.Database) throws {
        try db.create(table: "todo") { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("remoteId", .text).unique()
            t.column("title", .text).notNull()
            t.column("isCompleted", .boolean).notNull()
            t.column("syncStatus", .blob).notNull()
            t.column("lastModified", .datetime).notNull()
        }
    }
}
