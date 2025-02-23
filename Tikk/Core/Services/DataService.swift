//
//  APIService.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 14/02/2025.
//

import SwiftUI
import Combine
import Firebase
import FirebaseCore
import FirebaseFirestore

enum FirebaseError: Error {
    case documentIDMissing
    case addDocumentFailed(Error?)
    case deleteDocumentFailed(Error?)
    case updateDocumentFailed(Error?)
}

protocol FirebaseModel: Identifiable, Codable, Equatable {
    var id: String? { set get }
}

protocol DataService: ObservableObject {
    associatedtype Item: FirebaseModel

    func getData() -> AnyPublisher<[Item], Error>
    func add(_ item: Item) -> AnyPublisher<Void, Error>
    func update(_ item: Item) -> AnyPublisher<Void, Error>
    func delete(_ item: Item) -> AnyPublisher<Void, Error>
}

class FirebaseDataService<T : FirebaseModel>: ObservableObject, DataService {
    private let collectionName: String
    private let store = Firestore.firestore()

    @Published var items: [T] = []

    init(path: String) {
        self.collectionName = path
        getDataFromFirebase()
    }

    func getData() -> AnyPublisher<[T], Error> {
        $items
            .tryMap { $0 }
            .eraseToAnyPublisher()
    }

    func getDataFromFirebase() {
        store
            .collection(collectionName)
            .addSnapshotListener { (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }

                self.items = snapshot?.documents.compactMap {
                    try? $0.data(as: T.self)
                } ?? []
            }
    }

    func add(_ item: T) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try self.store
                    .collection(self.collectionName)
                    .addDocument(from: item) { error in
                        if let _ = error {
                            promise(.failure(FirebaseError.addDocumentFailed(error)))
                        } else {
                            promise(.success(()))
                        }
                    }
            } catch {
                promise(.failure(FirebaseError.addDocumentFailed(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    func delete(_ item: T) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let documentID = item.id else {
                promise(.failure(FirebaseError.documentIDMissing))
                return
            }

            self.store
                .collection(self.collectionName)
                .document(documentID)
                .delete { error in
                    self.handleCompletion(
                        operationError: error,
                        promise: promise
                    )
                }
        }
        .eraseToAnyPublisher()
    }

    func update(_ item: T) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let documentID = item.id else {
                promise(.failure(FirebaseError.documentIDMissing))
                return
            }
            do {
                try self.store
                    .collection(self.collectionName)
                    .document(documentID)
                    .setData(from: item) { error in
                        self.handleCompletion(
                            operationError: error,
                            promise: promise
                        )
                    }
            } catch {
                promise(.failure(FirebaseError.updateDocumentFailed(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    private func handleCompletion(
        operationError: Error?,
        promise: @escaping (Result<Void, Error>) -> Void
    ) {
        if let error = operationError {
            promise(.failure(error))
        } else {
            promise(.success(()))
        }
    }

}
