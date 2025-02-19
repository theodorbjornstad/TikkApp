//
//  TodoDetailViewModel.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import SwiftUI

extension TodoDetailViewModel {
    enum InteractionEvent {
        case commit
    }
}

@Observable
class TodoDetailViewModel {

    let placeholder: String = Asset.String.input_placeholder
    var selectedText: String = ""

    private let onCommit: (Todo) -> Void

    init(onCommit: @escaping (Todo) -> Void) {
        self.onCommit = onCommit
        self.selectedText = ""
    }

    func handleEvent(_ event: InteractionEvent) {
        switch event {
        case .commit:
            onCommit(.init(
                title: selectedText,
                isCompleted: false,
                syncStatus: .pending,
                lastModified: .now
            ))
        }
    }
}
