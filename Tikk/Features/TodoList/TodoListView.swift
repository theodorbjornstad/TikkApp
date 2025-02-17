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
                categorySelector
                list
                Spacer()
            }
            floatingAddButton
        }
        .padding(16)
        .background(Asset.Color.background)
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

    private var categorySelector: some View {
        Selector(
            availableCategories: viewModel.availableCategories,
            selectedCategory: $viewModel.selectedCategory
        )
    }

    @ViewBuilder
    private var list: some View {
        if viewModel.selectedItems.isEmpty {
            emptyState
        } else {
            ScrollView {
                ForEach(viewModel.selectedItems) { item in
                    ListItem(
                        title: item.title,
                        category: item.category,
                        isChecked: item.isCompleted,
                        onCheck: { viewModel.handleEvent(.markCompleted(item)) }
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
