//
//  Task.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import Foundation
import GRDB

enum SyncStatus: String, Codable {
    case synced, pending
}


// TODO: remove identifiable
struct Todo: Identifiable, Equatable {
    var id: Int64?
    var remoteId: String?
    var title: String
    var isCompleted: Bool
    var syncStatus: SyncStatus
    var lastModified: Date
}

// TODO: Move
extension Todo: Codable, FetchableRecord, MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}
