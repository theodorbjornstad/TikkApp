//
//  TodoRepository.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 23/02/2025.
//

import SwiftUI
import Combine

protocol TodoRepository {
    func getData() -> AnyPublisher<[Todo], Error>
    func add(_ item: Todo) -> AnyPublisher<Void, Error>
    func update(_ item: Todo) -> AnyPublisher<Void, Error>
    func delete(_ item: Todo) -> AnyPublisher<Void, Error>
}

class TodoRepositoryImpl: TodoRepository {

    private let dataservice = FirebaseDataService<Todo>(path: "todos")

    func getData() -> AnyPublisher<[Todo], any Error> {
        dataservice.getData()
    }

    func add(_ item: Todo) -> AnyPublisher<Void, Error> {
        dataservice.add(item)
    }

    func update(_ item: Todo) -> AnyPublisher<Void, Error> {
        dataservice.update(item)
    }

    func delete(_ item: Todo) -> AnyPublisher<Void, Error> {
        dataservice.delete(item)
    }
}
