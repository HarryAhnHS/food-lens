//
//  SearchHistoryView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SearchHistoryView: View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    @State private var searchText : String  = ""
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return searchHistoryViewModel.products
        }
        else {
            return searchHistoryViewModel.products.filter { product in
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
                Text("No search history available.")
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
        .navigationTitle("Your Search History")
    }
}
