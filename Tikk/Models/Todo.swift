//
//  Task.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import Foundation

struct Todo: Identifiable, Equatable {
    let id: UUID
    var title: String
    let category: Category
    var isCompleted: Bool
    var needsSync: Bool
    var lastModified: Date

    init(
        id: UUID,
        title: String,
        category: Category
    ) {
        self.id = id
        self.title = title
        self.isCompleted = false
        self.category = category
        self.needsSync = true
        self.lastModified = .now
    }
}
