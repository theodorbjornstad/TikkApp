//
//  Injected+Dataservice.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 20/02/2025.
//

private struct DataserviceKey: InjectionKey {
    static var currentValue: FirebaseService = FirebaseService<Todo>(path: "todos")
}

extension InjectedValues {
    var dataService: FirebaseService<Todo> {
        get { Self[DataserviceKey.self] }
        set { Self[DataserviceKey.self] = newValue }
    }
}
