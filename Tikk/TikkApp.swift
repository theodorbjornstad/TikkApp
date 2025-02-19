//
//  TikkApp.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

// class AppDelegate: NSObject, UIApplicationDelegate {
//     func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//     ) -> Bool {
//         FirebaseApp.configure()
//         return true
//     }
// }

@main
struct TikkApp: App {

    // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let databaseService = DatabaseServiceImp(databaseClient: .persistent)
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
