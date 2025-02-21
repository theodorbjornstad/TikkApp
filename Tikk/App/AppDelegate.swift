//
//  AppDelegate.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 21/02/2025.
//

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
