//
//  SearchListView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

// General search list view displaying list of products passed as param
// Used by Saved Search Views and Search History Views to display SearchItems

struct SearchListView: View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    @State private var searchText : String  = ""
    
    let products : [Product] // pass in environement managed product array
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        }
        else {
            return products.filter { product in
                if let productName = product.productName {
                    return productName.localizedCaseInsensitiveContains(searchText)
                }
                return false
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if products.isEmpty {
                Text("No searches available.")
                    .foregroundColor(.gray)
            }
            else {
                // List all products with optional search filter
                List(filteredProducts) { product in
                    SearchItemView(product: product)
                        .padding(.vertical, 8)
                }
                .refreshable {
                    searchHistoryViewModel.fetchSearches()
                    // Refreshable  - manually refresh to directly reflect changes
                }
                .searchable(
                    text: $searchText,
                    placement: .automatic,
                    prompt: "Search"
                )
                .textInputAutocapitalization(.never)
            }
        }
    }
}
