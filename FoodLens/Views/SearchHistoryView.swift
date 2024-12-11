//
//  SearchHistoryView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SearchHistoryView: View {
    let searches : [UserSearch]

    var body: some View {
        VStack(alignment: .leading) {
            if searches.isEmpty {
                Text("No search history available.")
                    .foregroundColor(.gray)
            } 
            else {
                List(searches) { search in
                    SearchItemView(barcode: search.barcode, timestamp: search.timestamp)
                        .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Search History")
    }
}
