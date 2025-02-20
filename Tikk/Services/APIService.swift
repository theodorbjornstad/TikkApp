//
//  APIService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 14/02/2025.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

protocol APIService {
    func fetchTodos(lastSyncTimestamp: Date) async throws -> [TodoApiDao]
    func saveTodo(_ todo: Todo) async throws
    func addTodo(_ todo: Todo) async throws -> String
}

class APIServiceImp: APIService {

    let firestore: Firestore

    init() {
        FirebaseApp.configure()
        self.firestore = Firestore.firestore()
    }

    private let collection = "todos"

    func fetchTodos(lastSyncTimestamp: Date) async throws -> [TodoApiDao] {
        try await firestore
            .collection(collection)
            .whereField("lastModified", isGreaterThan: Timestamp(date: lastSyncTimestamp))
            .getDocuments()
            .documents
            .compactMap { snapshot -> TodoApiDao? in
                let decodedModel = try? snapshot.data(as: TodoApiDao.self)
                print("❌ Decoding error: \(decodedModel)")
                return decodedModel
            }
    }


    func saveTodo(_ todo: Todo) async throws {
        print("☁️ Saving todo: \(todo)")
        guard let documentId = todo.remoteId else {
            // TODO: Throw error
            return
        }
        let collection = try await firestore
            .collection(collection)
            .document(documentId)
            .setData([
            "title": todo.title,
            "completed": todo.isCompleted,
            "lastModified": Timestamp(date: todo.lastModified)
        ], merge: true)
    }

    func addTodo(_ todo: Todo) async throws -> String {
        print("☁️ Adding todo: \(todo)")
        return try await firestore.collection(collection).addDocument(data: [
            "title": todo.title,
            "completed": todo.isCompleted,
            "lastModified": Timestamp(date: todo.lastModified)
        ]).documentID
    }
}

struct TodoApiDao: Decodable {
    @DocumentID var id: String?
    let title: String
    let completed: Bool
    let lastModified: Date
}
