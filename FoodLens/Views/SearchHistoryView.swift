//
//  SearchHistoryView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SearchHistoryView: View {
    @EnvironmentObject var searchHistoryViewModel : SearchHistoryViewModel
    
    let searches : [UserSearch]
    let products : [Product]

    var body: some View {
        VStack(alignment: .leading) {
            if searches.isEmpty {
                Text("No search history available.")
                    .foregroundColor(.gray)
            } 
            else {
                List(products) { product in
                    SearchItemView(product: product)
                        .padding(.vertical, 8)
                }
                .refreshable {
                    searchHistoryViewModel.fetchSearches()
                    // Refreshable option - manually refresh to directly reflect changes
                }
            }
        }
        .navigationTitle("Your Search History")
    }
}
