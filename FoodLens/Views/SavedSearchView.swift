//
//  SavedSearchView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SavedSearchView: View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel

    let searches : [UserSearch]
    let products : [Product]

    var body: some View {
        VStack(alignment: .leading) {
            let savedProducts = products.filter { $0.isSaved }

            if savedProducts.isEmpty {
                Text("No saved searches available.")
                    .foregroundColor(.gray)
            } else {
                List(savedProducts) { product in
                    SearchItemView(product: product)
                        .padding(.vertical, 8)
                }
                .refreshable {
                    searchHistoryViewModel.fetchSearches()
                    // Refreshable option - manually refresh to directly reflect changes
                }
            }
        }
        .navigationTitle("Your Saved Searches")
    }
}
