//
//  TodoListViewModelTests.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 23/02/2025.
//

import XCTest
import Combine
@testable import Tikk

@MainActor
class TodoListViewModelTests: XCTestCase {

    private var sut: TodoListViewModel!
    private var mockTodoRepository: MockTodoRepository!
    private var mockNetworkMonitorService: MockNetworkMonitorService!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockTodoRepository = MockTodoRepository()
        mockNetworkMonitorService = MockNetworkMonitorService()
        InjectedValues[\.todoRepository] = mockTodoRepository
        InjectedValues[\.networkMonitorService] = mockNetworkMonitorService
        sut = TodoListViewModel()
    }

    override func tearDown() {
        sut = nil
        mockTodoRepository = nil
        mockNetworkMonitorService = nil
        super.tearDown()
    }

    func testHandleEvent_createItem_shouldSetUseCaseToAdd() {
        // When
        sut.handleEvent(.createItem)

        // Then
        XCTAssertEqual(sut.useCase, .add)
    }

    func testHandleEvent_editItem_shouldSetUseCaseToEdit() {
        // Given
        let todo = Todo(title: "Test Task", completed: false)

        // When
        sut.handleEvent(.editItem(todo))

        // Then
        XCTAssertEqual(sut.useCase, .edit(todo))
    }

    func testHandleEvent_toggleCompleted_shouldUpdateTodo() {
        // Given
        let todo = Todo(title: "Test Task", completed: false)
        mockTodoRepository.mockUpdateResult = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

        // When
        sut.handleEvent(.toggleCompleted(todo))

        // Then
        XCTAssertTrue(mockTodoRepository.updateCalled, "Update should have been called on repository")
    }

    func testHandleSheetEvent_saveNewItem_shouldCallAdd() {
        // Given
        let newTodo = Todo(title: "New Task", completed: false)
        mockTodoRepository.mockAddResult = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        sut.handleEvent(.createItem)

        // When
        sut.handleSheetEvent(.save(newTodo))

        // Then
        XCTAssertTrue(mockTodoRepository.addCalled, "Add should have been called on repository")
    }

    func testHandleSheetEvent_saveEditedItem_shouldCallUpdate() {
        // Given
        let existingTodo = Todo(title: "Existing Task", completed: false)
        mockTodoRepository.mockUpdateResult = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

        sut.handleEvent(.editItem(existingTodo))

        // When
        sut.handleSheetEvent(.save(existingTodo))

        // Then
        XCTAssertTrue(mockTodoRepository.updateCalled, "Update should have been called on repository")
    }

    func testHandleSheetEvent_deleteItem_shouldCallDelete() {
        // Given
        let todo = Todo(title: "Task to Delete", completed: false)
        sut.useCase = .edit(todo)

        // When
        sut.handleSheetEvent(.delete(todo))

        // Then
        XCTAssertTrue(mockTodoRepository.deleteCalled, "Delete should have been called on repository")
    }

    func testObserveNetworkStatus_shouldUpdateToolbarIcon() {
        // Given
        let expectation = XCTestExpectation(description: "Network status should be updated")

        sut.$isOnline
            .dropFirst()
            .sink { isOnline in
                XCTAssertFalse(isOnline, "isOnline should be updated to false")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        mockNetworkMonitorService.sendNetworkStatus(false)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.toolbarIcon, Asset.Icon.offline)
    }

    func testErrorHandling_shouldSetListError() {
        // Given
        let expectation = XCTestExpectation(description: "Error should be set")
        let testError = FirebaseError.addDocumentFailed(nil)
        mockTodoRepository.mockAddResult = Fail(error: testError).eraseToAnyPublisher()
        sut.useCase = .add

        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error?.message, "Error adding the document.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        sut.handleSheetEvent(.save(Todo(title: "Failing Task", completed: false)))

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
