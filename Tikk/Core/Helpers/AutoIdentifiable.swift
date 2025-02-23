//
//  AutoIdentifiable.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 23/02/2025.
//

protocol AutoIdentifiable: Identifiable, Hashable {}

extension Identifiable where Self: AutoIdentifiable {
    var id: Int { hashValue }
}
