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

    @StateObject var viewModel = TodoListViewModel()

    var body: some View {
        NavigationView {
            content
        }
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
        .ignoresSafeArea(.keyboard)
        .navigationBarTitle(Asset.String.navbar_header, displayMode: .inline)
        .toolbar { toolbarIcon }
        .sheet(item: $viewModel.sheetAction) { detailSheet($0) }
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
                    style: .regular,
                    size: .medium,
                    action: { viewModel.handleEvent(.createItem) },
                    state: .idle
                )
            }
        }
    }

    private func detailSheet(_ action: TodoDetailViewModel.Action) -> some View {
        TodoDetailView(viewModel: .init(
            action: action,
            onCommit: { viewModel.handleEvent(.closeSheet) }
        ))
        .presentationDetents([.height(160)])
    }

    private var toolbarIcon: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image(systemName: viewModel.toolbarIcon)
                .font(.title2)
        }
    }
}
