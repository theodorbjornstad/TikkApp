//
//  CategorySelector.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 13/02/2025.
//

import SwiftUI

struct CategorySelector: View {

    let availableCategories: [Category]
    @Binding var selectedCategory: Category

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(availableCategories) { category in
                    CategoryPill(
                        title: category.title,
                        isSelected: category == selectedCategory
                    )
                    .onTapGesture {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCategory = Category.personal

    VStack {
        CategorySelector(
            availableCategories: [.personal, .work],
            selectedCategory: $selectedCategory
        )
    }
}
