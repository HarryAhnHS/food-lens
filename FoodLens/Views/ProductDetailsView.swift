//
//  ProductDetailsView.swift
//  FoodLens
//
//  Created by Harry Ahn on 9/12/2024.
//

import SwiftUI
import Social

// See ProductDetailsModel for decodable objects for json parses

struct ProductDetailsView: View {
    let product: Product
    @EnvironmentObject var searchHistoryViewModel: SearchHistoryViewModel
    @State private var isSaved: Bool = false // Local state to track save status

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Meta Details
                productImageSection
                productHeadSection
                saveButtonSection
                HStack(spacing: 8) {
                    shareButtonSection
                    openFoodFactsLinkButtonSection
                }

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
                // Set isSaved to previous state if exists
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

    private var productHeadSection: some View {
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
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var shareButtonSection: some View {
        Button(action: shareProduct) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
    
    // Link to respctive openFoodFacts weblink with further facts
    private var openFoodFactsLinkButtonSection: some View {
        Button(action: {
            if let url = URL(string: "https://world.openfoodfacts.org/product/\(product.code)") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: "link")
                Text("View on OpenFoodFacts")
                    .font(.caption)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
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
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
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
    
    // Helper function to share using SocialKit Framework
    func shareProduct() {
        guard let productName = product.productName else { return }
        // Multiline String as share content
        let shareContent = """
        🌟 I just scanned \(productName) with FoodLens!
        \(product.nutriments?.energyKcal.map { "Calories: \($0) kcal" } ?? "")
        \(product.ecoscoreGrade.map { "Eco-Score: \($0.uppercased())" } ?? "")
        \(product.nutriscoreGrade.map { "Nutri-Score: \($0.uppercased())" } ?? "")
        
        Be best equipped for your purchase with FoodLens!
        """

        var activityItems: [Any] = [shareContent]
        
        // Add product image if exist
        if let imageUrl = product.imageUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
            activityItems.append(image)
        }

        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        // Present the UIActivityViewController 
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }

}
