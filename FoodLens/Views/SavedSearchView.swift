//
//  SavedSearchView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SavedSearchView: View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    @State private var searchText : String  = ""
        
    var filteredProducts: [Product] {
        let savedProducts = searchHistoryViewModel.products.filter {
            $0.isSaved
        }
        if searchText.isEmpty {
            return savedProducts
        }
        else {
            return savedProducts.filter { product in
                if let productName = product.productName {
                    return productName.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            if filteredProducts.isEmpty {
                Text("No saved searches available.")
                    .foregroundColor(.gray)
            } else {
                // list all saved products
                List(filteredProducts) { product in
                    SearchItemView(product: product)
                        .padding(.vertical, 8)
                }
                .refreshable {
                    searchHistoryViewModel.fetchSearches()
                    // Refreshable option - manually refresh to directly reflect changes
                }
                .searchable(
                    text: $searchText,
                    placement: .automatic,
                    prompt: "Search"
                )
                .textInputAutocapitalization(.never)
            }
        }
//        .onAppear {
//            // Update and populate searches array when clicked
//            searchHistoryViewModel.fetchSearches()
//        }
        .navigationTitle("Your Saved Searches")
    }
}
