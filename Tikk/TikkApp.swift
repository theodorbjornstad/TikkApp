//
//  TikkApp.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import SwiftData

@main
struct TikkApp: App {

    let databaseService = DatabaseServiceImp()
    let apiService = APIServiceImp()

    var body: some Scene {
        WindowGroup {
            TodoListView(
                apiService: apiService,
                databaseService: databaseService
            )
        }
    }
}
