//
//  Category.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct Category: Identifiable, Equatable, Hashable {
    let id: UUID
    let title: String
    let color: Color
}


// TODO: Move to database??
extension Category {
    static let all: Category = .init(id: UUID(), title: "All", color: Color.white)
    static let none: Category = .init(id: UUID(), title: "No Category", color: Color.gray)
    static let work: Category = .init(id: UUID(), title: "Work", color: Color.green)
    static let personal: Category = .init(id: UUID(), title: "Personal", color: .red)
}
