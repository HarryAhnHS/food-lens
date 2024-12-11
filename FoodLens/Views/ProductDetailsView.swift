//
//  ProductDetailsView.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//

import SwiftUI

// See ProductDetailsModel for decodable objects for json parse

struct ProductDetailsView: View {
    let product: Product
    @EnvironmentObject var searchHistoryViewModel: SearchHistoryViewModel
    @State private var isSaved: Bool = false // Local state to track save status

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Meta Details
                productImageSection
                productNameAndBrandSection
                saveButtonSection

                // Ingredients Button
                if let ingredients = product.ingredients {
                    ingredientsButtonSection(ingredients: ingredients)
                }
                else {
                    Text("No Ingredients Found")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(8)
                }

                // Nutrition table
                if let nutriScore = product.nutriscoreGrade {
                    scoresSection(nutriScore: nutriScore, novaGroup: product.novaGroup, ecoScore: product.ecoscoreGrade)
                }
                
                // Scores section
                if let nutriments = product.nutriments {
                    nutritionalSummarySection(nutriments: nutriments)
                }

                // Origins - if not empty
                if let origins = product.origins, !origins.isEmpty {
                    originsSection(origins: origins)
                }

                // Allergen Warnings - if not empty
                if let allergens = product.allergens, !allergens.isEmpty {
                    allergenWarningsSection(allergens: allergens)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Product Details")
        .onAppear {
            if let search = searchHistoryViewModel.searches.first(where: { $0.barcode == product.code }) {
                isSaved = search.isSaved
            }
        }
    }

    // MARK: - Sections
    private var productImageSection: some View {
        Group {
            if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 4)
                } placeholder: {
                    ProgressView()
                        .frame(height: 200)
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(
                        Text("No Image")
                            .font(.caption)
                            .foregroundColor(.gray)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }

    private var productNameAndBrandSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let productName = product.productName {
                Text(productName)
                    .font(.title)
                    .bold()
            }
            if let brands = product.brands {
                Text("Brand: \(brands)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cornerRadius(8)
    }

    private var saveButtonSection: some View {
        Button(action: toggleSave) {
            HStack {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                Text(isSaved ? "Saved" : "Save")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSaved ? Color.orange : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }

    private func ingredientsButtonSection(ingredients: [Ingredient]) -> some View {
        let uniqueIngredients = Set(ingredients.map { $0.text.lowercased() })
        let capitalizedIngredients = uniqueIngredients.map { $0.capitalized }.sorted()

        return (
            NavigationLink(destination: ProductIngredientsListView(ingredients: capitalizedIngredients)) {
                Text("View And Search Ingredients")
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
            }
                .frame(maxWidth: .infinity)
        )
    }

    private func scoresSection(nutriScore: String?, novaGroup: Int?, ecoScore: String?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Scores")
                .font(.headline)
                .frame(maxWidth: .infinity)

            HStack {
                if let novaGroup = novaGroup {
                    scoreItem(label: "NOVA Group", value: "\(novaGroup)", color: novaGroup <= 2 ? .green : .red)
                } else {
                    scoreItem(label: "NOVA Group", value: "N/A", color: .secondary)
                }
                
                if let ecoScore = ecoScore, ecoScore.lowercased() != "not-applicable" {
                    scoreItem(label: "Eco Score", value: ecoScore.uppercased(), color: .blue)
                } else {
                    scoreItem(label: "Eco Score", value: "N/A", color: .secondary)
                }

                if let nutriScore = nutriScore, nutriScore.lowercased() != "unknown" {
                    scoreItem(label: "Nutri-Score", value: nutriScore.uppercased(), color: .yellow)
                } else {
                    scoreItem(label: "Nutri-Score", value: "N/A", color: .secondary)
                }
            }
        }
        .padding()
        .cornerRadius(8)
        .background(Color(UIColor.secondarySystemBackground))
        .frame(maxWidth: .infinity)
    }

    private func nutritionalSummarySection(nutriments: Nutriments) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutritional Summary")
                .font(.headline)
                .frame(maxWidth: .infinity)

            if let energy = nutriments.energyKcal {
                nutritionalItem(label: "Energy", value: "\(energy.rounded(toPlaces: 1)) kcal")
            }
            if let fat = nutriments.fat {
                nutritionalItem(label: "Fat", value: "\(fat.rounded(toPlaces: 1)) g")
            }
            if let sugars = nutriments.sugars {
                nutritionalItem(label: "Sugars", value: "\(sugars.rounded(toPlaces: 1)) g")
            }
            if let salt = nutriments.salt {
                nutritionalItem(label: "Salt", value: "\(salt.rounded(toPlaces: 1)) g")
            }
            if let saturatedFat = nutriments.saturatedFat {
                nutritionalItem(label: "Saturated Fat", value: "\(saturatedFat.rounded(toPlaces: 1)) g")
            }
            
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }

    private func originsSection(origins: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Origins")
                .font(.headline)
                .frame(maxWidth: .infinity)
            Text(origins)
                .font(.body)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }

    private func allergenWarningsSection(allergens: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Allergen Warnings")
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            Text(allergens)
                .font(.body)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Small cell Views
    private func scoreItem(label: String, value: String, color: Color) -> some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }

    private func nutritionalItem(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }

    private func toggleSave() {
        guard let search = searchHistoryViewModel.searches.first(where: { $0.barcode == product.code }) else {
            print("Search not found in history")
            return
        }
        searchHistoryViewModel.toggleSave(search: search)
        isSaved.toggle()
    }
}
