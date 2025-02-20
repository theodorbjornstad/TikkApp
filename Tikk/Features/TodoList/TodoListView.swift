//
//  TodoListView.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI
import SwiftData
import Lottie

struct TodoListView: View {

    @StateObject var viewModel: TodoListViewModel<FirebaseService<Todo>>
    @State var hasPlayed: Bool = false

    var body: some View {
        NavigationView {
            if hasPlayed {
                content
            } else {
                splashScreen
            }
        }
        .sheet(item: $viewModel.showInputSheet) { item in
            TodoDetailView(
                item: item,
                onCommit: { viewModel.handleEvent(.commitItem($0)) }
            )
            .presentationDetents([.height(160), .medium])
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

    private var content: some View {
        ZStack {
            VStack(alignment: .center, spacing: 16) {
                list
                Spacer()
            }
            floatingAddButton
        }
        .padding(16)
        .background(Asset.Color.background)
        .navigationBarTitle(Asset.String.navbar_header, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: viewModel.toolbarIcon)
                    .font(.title2)
            }
        }
    }

    var emptyState: some View {
        VStack(alignment: .center) {
            LottieView(animation: .named(Asset.Animation.emptyState))
                .playing(loopMode: .loop)
                .frame(width: 200, height: 200)

            Text(Asset.String.list_no_content)
                .font(.callout)
        }
    }

    @ViewBuilder
    private var list: some View {
        if viewModel.items.isEmpty {
            emptyState
        } else {
            ScrollView {
                ForEach(viewModel.items, id: \.id) { item in
                    ListItem(
                        title: item.title,
                        isChecked: item.completed,
                        onCheck: { viewModel.handleEvent(.toggleCompleted(item)) }
                    )
                    .onTapGesture { viewModel.handleEvent(.editItem(item)) }
                }
            }
        }
    }

    private var floatingAddButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                CircularButton(
                    imageName: Asset.Icon.plus,
                    size: .medium,
                    action: { viewModel.handleEvent(.createItem) }
                )
            }
        }
    }
}
