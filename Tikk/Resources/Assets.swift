//
//  ColorAsset.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

enum Asset {
    enum Color {
        static let textPrimary = SwiftUI.Color.black
        static let textSecondary = SwiftUI.Color.gray

        static let primary = SwiftUI.Color.blue
        static let background = SwiftUI.Color.gray.opacity(0.2)
        static let surface = SwiftUI.Color.white
    }
    enum Animation {
        static let splashScreen = "animation_splash"
        static let emptyState = "animation_empty"
    }
    enum Icon {
        static let plus = "plus"
        static let checkmark = "checkmark"
        static let online = "wifi"
        static let offline = "wifi.slash"
        static let delete = "xmark"
    }
    enum String {
        static let input_placeholder = "Input new task here"
        static let list_no_content = "No tasks? Guess you’ve mastered life"
        static let navbar_header = "Your Ticks"

        static let error_documentIDMissing = "The document does not have a valid ID."
        static let error_addDocumentFailed = "Error adding the document."
        static let error_deleteDocumentFailed = "Error deleting the document."
        static let error_updateDocumentFailed = "Error updating the document."
        static let error_dismiss = "Ok"
        static let error_title = "Error"
    }
}
