//
//  MockTodoRepository.swift
//  TikkTests
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import Combine
@testable import Tikk

class MockTodoRepository: TodoRepository {
    var mockGetDataResult: AnyPublisher<[Todo], Error> = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    var mockAddResult: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    var mockUpdateResult: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    var mockDeleteResult: AnyPublisher<Void, Error> = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

    var addCalled = false
    var updateCalled = false
    var deleteCalled = false

    func getData() -> AnyPublisher<[Todo], Error> {
        return mockGetDataResult
    }

    func add(_ item: Todo) -> AnyPublisher<Void, Error> {
        addCalled = true
        return mockAddResult
    }

    func update(_ item: Todo) -> AnyPublisher<Void, Error> {
        updateCalled = true
        return mockUpdateResult
    }

    func delete(_ item: Todo) -> AnyPublisher<Void, Error> {
        deleteCalled = true
        return mockDeleteResult
    }
}
