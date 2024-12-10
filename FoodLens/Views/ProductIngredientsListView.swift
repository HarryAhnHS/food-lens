//
//  ProductIngredientsView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct ProductIngredientsListView: View {
    let ingredients: [String]
    @State private var searchText: String = ""

    // Dynamically filtered ingredients based on search text
    var filteredIngredients: [String] {
        if searchText.isEmpty {
            return ingredients
        } else {
            return ingredients.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        List {
            ForEach(filteredIngredients, id: \.self) { ingredient in
                Text(ingredient)
            }
        }
        .searchable(
            text: $searchText,
            placement: .automatic,
            prompt: "Search for an ingredient"
        )
        .textInputAutocapitalization(.never)
        .navigationTitle("Ingredients")
    }
}

