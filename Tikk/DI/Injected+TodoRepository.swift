//
//  Injected+TodoRepository.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 20/02/2025.
//

private struct TodoRepositoryKey: InjectionKey {
    static var currentValue: TodoRepository = TodoRepositoryImpl()
}

extension InjectedValues {
    var todoRepository: TodoRepository {
        get { Self[TodoRepositoryKey.self] }
        set { Self[TodoRepositoryKey.self] = newValue }
    }
}
