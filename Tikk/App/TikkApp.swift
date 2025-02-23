//
//  TikkApp.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

@main
struct TikkApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var hasPlayedAnimation = false

    var body: some Scene {
        WindowGroup {
            if hasPlayedAnimation {
                TodoListView()
            } else {
                splashView
            }
        }
    }

    private var splashView: some View {
        SplashView(onFinished: {
            Task {
                try await Task.sleep(nanoseconds: 600_000_000)
                hasPlayedAnimation = true
            }
        })
    }
}
