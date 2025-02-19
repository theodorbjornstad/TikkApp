//
//  Task.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import Foundation
import GRDB

struct Todo: Codable, Identifiable, Equatable {
    var id: Int64?
    var title: String
    let categoryId: String?
    var isCompleted: Bool
    var needsSync: Bool
    var lastModified: Date
}


// TODO: Move
extension Todo: FetchableRecord, PersistableRecord {}
