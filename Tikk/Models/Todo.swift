//
//  Task.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Todo: FirebaseModelType {
    @DocumentID var id: String?
    var title: String
    var completed: Bool
}

protocol AutoIdentifiable: Identifiable, Hashable {}

extension Identifiable where Self: AutoIdentifiable {
    var id: Int { hashValue }
}
