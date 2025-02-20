//
//  TikkApp.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TikkApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var hasPlayed = false

    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
    }

    private var splashScreen: some View {
        SplashScreen(onFinished: {
            Task {
                try await Task.sleep(nanoseconds: 600_000_000)
                hasPlayed = true
            }
        })
    }
}
