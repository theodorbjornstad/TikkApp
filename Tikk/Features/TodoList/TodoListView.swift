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
    init(
        apiService: APIService,
        databaseService: DatabaseService
    ) {
        self.hasPlayed = false
        self._viewModel = State(wrappedValue: .init(
           todoRepository: TodoRepositoryImp(
               apiService: apiService,
               databaseService: databaseService
           )
       ))
    }

    @State var viewModel: TodoListViewModel
    @State var hasPlayed: Bool

    var body: some View {
        NavigationView {
            if hasPlayed {
                content
            } else {
                splashScreen
            }
        }
        .sheet(isPresented: $viewModel.showInputSheet) {
            TodoDetailView(onCommit: { viewModel.handleEvent(.commitItem($0)) })
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
        .navigationBarTitle("My To-Do List", displayMode: .inline)
        .toolbar { refreshButton }
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

    var refreshButton: some View {
        Button(action: { viewModel.handleEvent(.refresh) }) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .font(.title)
                .foregroundColor(.blue)
        }
    }

    @ViewBuilder
    private var list: some View {
        if viewModel.items.isEmpty {
            emptyState
        } else {
            ScrollView {
                ForEach(viewModel.items) { item in
                    ListItem(
                        title: item.title,
                        isChecked: item.isCompleted,
                        onCheck: { viewModel.handleEvent(.toggleCompleted(item)) }
                    )
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
