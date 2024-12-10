//
//  ProductQuickFactsView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

//import SwiftUI
//
//struct ProductSummaryView: View {
//    let product: Product
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
//                AsyncImage(url: url)
//                    .frame(height: 200)
//                    .clipped()
//            }
//
//            Text(product.productName ?? "Unknown Product")
//                .font(.headline)
//                .padding(.bottom, 5)
//
//            if let brands = product.brands {
//                Text("Brand: \(brands)")
//                    .font(.subheadline)
//            }
//
//            if let ecoscoreGrade = product.ecoscoreGrade {
//                Text("Eco-Score: \(ecoscoreGrade.uppercased())")
//                    .font(.subheadline)
//            }
//
//            if let nutriments = product.nutriments {
//                Text("Nutrition Facts (per 100g):")
//                    .font(.subheadline)
//                    .padding(.top, 5)
//                Text("Calories: \(nutriments.energyKcal ?? 0) kcal")
//                Text("Fat: \(nutriments.fat ?? 0) g")
//                Text("Saturated Fat: \(nutriments.saturatedFat ?? 0) g")
//                Text("Sugars: \(nutriments.sugars ?? 0) g")
//                Text("Salt: \(nutriments.salt ?? 0) g")
//            }
//        }
//        .padding()
//    }
//}
