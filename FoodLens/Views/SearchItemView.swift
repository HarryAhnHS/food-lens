//
//  SearchItemView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct SearchItemView: View {
    let product: Product

    var body: some View {
        VStack {
            NavigationLink(destination: ProductDetailsView(product: product)) {
                HStack(spacing: 16) {
                    // Product Image
                    if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 4)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("No Image")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            )
                    }

                    // Product Details
                    VStack(alignment: .leading, spacing: 4) {
                        if let productName = product.productName {
                            Text(productName)
                                .font(.headline)
                                .lineLimit(1)
                        } else {
                            Text("Unknown Product")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }

                        if let brands = product.brands {
                            Text(brands)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        // Timestamp
                        if let timestamp = product.timestamp {
                            Text("Scanned \(timestamp.timeAgoDisplay())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle()) // Removes default button styling
        }
    }
}
