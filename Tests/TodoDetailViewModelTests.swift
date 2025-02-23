//
//  TodoDetailViewModelTests.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 23/02/2025.
//

import XCTest
import Combine
@testable import Tikk

@MainActor
class TodoDetailViewModelTests: XCTestCase {

    func testInit_withAddUseCase_shouldHaveEmptyTitle() {
        // Given
        let viewModel = TodoDetailViewModel(
            useCase: .add,
            onDelete: { _ in },
            onSave: { _ in }
        )

        // Then
        XCTAssertEqual(viewModel.title, "", "Title should be empty for add use case")
        XCTAssertFalse(viewModel.showDeleteButton, "Delete button should not be visible for add use case")
        XCTAssertEqual(viewModel.saveButtonState, .disabled, "Save button should be disabled initially")
    }

    func testInit_withEditUseCase_shouldHaveInitialTitle() {
        // Given
        let todo = Todo(title: "Test Todo", completed: false)
        let viewModel = TodoDetailViewModel(
            useCase: .edit(todo),
            onDelete: { _ in },
            onSave: { _ in }
        )

        // Then
        XCTAssertEqual(viewModel.title, todo.title, "Title should match the existing todo")
        XCTAssertTrue(viewModel.showDeleteButton, "Delete button should be visible for edit use case")
        XCTAssertEqual(viewModel.saveButtonState, .disabled, "Save button should be disabled initially")
    }

    func testSave_shouldCallOnSaveWithNewTodo_whenAdding() {
        // Given
        let expectation = XCTestExpectation(description: "onSave should be called with a new todo")
        var savedTodo: Todo?

        let viewModel = TodoDetailViewModel(
            useCase: .add,
            onDelete: { _ in },
            onSave: { todo in
                savedTodo = todo
                expectation.fulfill()
            }
        )

        // When
        viewModel.title = "New Todo"
        viewModel.handleEvent(.save)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(savedTodo?.title, "New Todo", "Saved todo should have updated title")
        XCTAssertFalse(savedTodo?.completed ?? true, "New todo should be incomplete by default")
    }

    func testSave_shouldCallOnSaveWithUpdatedTodo_whenEditing() {
        // Given
        let todo = Todo(title: "Existing Todo", completed: false)
        let expectation = XCTestExpectation(description: "onSave should be called with an updated todo")
        var updatedTodo: Todo?

        let viewModel = TodoDetailViewModel(
            useCase: .edit(todo),
            onDelete: { _ in },
            onSave: { todo in
                updatedTodo = todo
                expectation.fulfill()
            }
        )

        // When
        viewModel.title = "Updated Todo"
        viewModel.handleEvent(.save)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(updatedTodo?.title, "Updated Todo", "Updated todo should have the new title")
    }

    func testSaveButtonState_shouldBeIdle_whenTitleChanges() {
        // Given
        let viewModel = TodoDetailViewModel(
            useCase: .add,
            onDelete: { _ in },
            onSave: { _ in }
        )

        // When
        viewModel.title = "New Task"

        // Then
        XCTAssertEqual(viewModel.saveButtonState, .idle, "Save button should be enabled when title is changed")
    }

    func testDelete_shouldCallOnDelete_whenEditing() {
        // Given
        let todo = Todo(title: "Existing Todo", completed: false)
        let expectation = XCTestExpectation(description: "onDelete should be called with the existing todo")
        var deletedTodo: Todo?

        let viewModel = TodoDetailViewModel(
            useCase: .edit(todo),
            onDelete: { todo in
                deletedTodo = todo
                expectation.fulfill()
            },
            onSave: { _ in }
        )

        // When
        viewModel.handleEvent(.delete)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(deletedTodo?.title, "Existing Todo", "Deleted todo should match the original")
    }

    func testDelete_shouldNotCallOnDelete_whenAdding() {
        // Given
        let expectation = XCTestExpectation(description: "onDelete should not be called")
        expectation.isInverted = true

        let viewModel = TodoDetailViewModel(
            useCase: .add,
            onDelete: { _ in
                expectation.fulfill()
            },
            onSave: { _ in }
        )

        // When
        viewModel.handleEvent(.delete)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
