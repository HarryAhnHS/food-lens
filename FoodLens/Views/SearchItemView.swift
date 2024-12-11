//
//  SearchItemView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

import SwiftUI

struct SearchItemView: View {
    let barcode: String
    let timestamp: Date
    @State private var product: Product?
    @State private var isLoading = false
    @State private var showDetails = false

    var body: some View {
        VStack(alignment: .leading) {
            if let product = product {
                // Display the product information
                NavigationLink(destination: ProductDetailsView(product: product)) {
                    VStack(alignment: .leading) {
                        Text(product.productName ?? "Unknown Product")
                            .font(.headline)
                        Text("Barcode: \(barcode)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Scanned on: \(timestamp, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else if isLoading {
                // Show a loading indicator while fetching the product
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                // Show the barcode and timestamp if no product details are fetched yet
                VStack(alignment: .leading) {
                    Text("Barcode: \(barcode)")
                        .font(.subheadline)
                        .bold()
                    Text("Scanned on: \(timestamp, style: .date)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .onAppear {
                    fetchProductDetails()
                }
            }
        }
        .contentShape(Rectangle()) // Makes the entire cell tappable
    }

    private func fetchProductDetails() {
        isLoading = true
        fetchProductInfo(for: barcode) { fetchedProduct in
            DispatchQueue.main.async {
                self.isLoading = false
                if let fetchedProduct = fetchedProduct {
                    self.product = fetchedProduct
                    self.showDetails = true
                } else {
                    print("Failed to fetch product details for barcode: \(barcode)")
                }
            }
        }
    }
}
