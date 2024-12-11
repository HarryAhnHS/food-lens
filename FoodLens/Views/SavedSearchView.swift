//
//  SavedSearchView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SavedSearchView: View {
    let searches : [UserSearch]

    var body: some View {
        VStack(alignment: .leading) {
            let savedSearches = searches.filter { $0.isSaved }
            if savedSearches.isEmpty {
                Text("No saved searches available.")
                    .foregroundColor(.gray)
            } else {
                List(savedSearches) { search in
                    SearchItemView(barcode: search.barcode, timestamp: search.timestamp)
                        .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Saved Searches")
    }
}
