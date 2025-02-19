//
//  TikkTests.swift
//  TikkTests
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import XCTest
import GRDB
@testable import Tikk

class DatabaseServiceTests: XCTestCase {

    var databaseService: DatabaseServiceImp!
    var databaseClient: GRDBClient!

    override func setUp() {
        super.setUp()
        do {
            let writer = try DatabasePool(path: "unit.test.sqlite")
            databaseClient = try GRDBClient(writer)
            databaseService = DatabaseServiceImp(databaseClient: databaseClient)
        } catch {
            XCTFail("Failed to set up database: \(error)")
        }
    }

    override func tearDown() {
        // Reset the database after each test to ensure clean state
        do {
            try databaseClient.writer.write { db in
                _ = try Todo.deleteAll(db)
            }
        } catch {
            XCTFail("Failed to clear database: \(error)")
        }
        super.tearDown()
    }

    // MARK: - Tests for fetchTodos
    func testFetchTodos_ReturnsCorrectData() throws {
        // Given
        let expectedTodo = Todo(id: 1, title: "test", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)

        // Insert the todo into the database
        try databaseService.addTodo(expectedTodo)

        // When
        let todos = try databaseService.fetchTodos()

        // Then
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.id, expectedTodo.id)
        XCTAssertEqual(todos.first?.title, expectedTodo.title)
    }

    // MARK: - Tests for addTodo
    func testAddTodo_InsertsDataCorrectly() throws {
        // Given
        let todo = Todo(id: 1, title: "test", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)

        // When
        try databaseService.addTodo(todo)

        // Then
        let todos = try databaseService.fetchTodos()
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, todo.title)
    }

    // MARK: - Tests for saveTodo
    func testSaveTodo_UpdatesDataCorrectly() throws {
        // Given
        var todo = Todo(id: 1, title: "test", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)
        try databaseService.addTodo(todo)

        // When
        todo.title = "Updated Todo"
        try databaseService.saveTodo(todo)

        // Then
        let todos = try databaseService.fetchTodos()
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "Updated Todo")
    }

    // MARK: - Tests for deleteTodo
    func testDeleteTodo_RemovesDataCorrectly() throws {
        // Given
        let todo = Todo(id: 1, title: "test", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)
        try databaseService.addTodo(todo)

        // When
        try databaseService.deleteTodo(todo)

        // Then
        let todos = try databaseService.fetchTodos()
        XCTAssertEqual(todos.count, 0)
    }

    // MARK: - Tests for overwrite
    func testOverwrite_OverwritesAllData() throws {
        // Given
        let todo = Todo(id: 1, title: "test", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)

        let initialTodos = [
            Todo(id: 1, title: "Todo 1", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now),
            Todo(id: 2, title: "Todo 2", categoryId: "",isCompleted: false, needsSync: true, lastModified: .now)
        ]
        try databaseService.overwrite(initialTodos)

        // When
        let newTodos = [
            Todo(id: 3, title: "New Todo", categoryId: "", isCompleted: true, needsSync: true, lastModified: .now)
        ]
        try databaseService.overwrite(newTodos)

        // Then
        let todos = try databaseService.fetchTodos()
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "New Todo")
    }
}
