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
    func fetchTodos(lastSyncTimestamp: Date) async throws -> [Todo]
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

    func fetchTodos(lastSyncTimestamp: Date) async throws -> [Todo] {
        let documents = try await firestore
            .collection(collection)
            .whereField("lastModified", isGreaterThan: Timestamp(date: lastSyncTimestamp))
            .getDocuments()
            .documents

        let data = documents.compactMap { snapshot -> Todo? in
            let data = snapshot.data()

            guard
                let title = data["title"] as? String,
                let lastModified = data["lastModified"] as? Timestamp,
                let isCompleted = data["isCompleted"] as? Bool
            else {
                print("Skipping document \(snapshot.documentID) due to missing or invalid fields")
                return nil
            }
            return Todo(
                id: nil,
                remoteId: snapshot.documentID,
                title: title,
                isCompleted: isCompleted,
                syncStatus: .synced,
                lastModified: lastModified.dateValue()
            )
        }
        return data
    }


    func saveTodo(_ todo: Todo) async throws {
        print("☁️ Saving todo: \(todo)")
        guard let documentId = todo.remoteId else {
            // TODO: Throw error
            return
        }
        try await firestore.collection(collection).document(documentId).setData([
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
