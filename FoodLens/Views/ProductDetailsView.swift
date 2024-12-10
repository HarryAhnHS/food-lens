import SwiftUI

struct ProductResponse: Decodable {
    let status: Int
    let statusVerbose: String
    let product: Product?
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusVerbose = "status_verbose"
        case product
    }
}

struct Product: Decodable {
    let code: String
    let productName: String?
    let brands: String?
    let ingredientsText: String?
    let ingredients: [Ingredient]?
    let nutriments: Nutriments?
    let ecoscoreGrade: String?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case code
        case productName = "product_name"
        case brands
        case ingredientsText = "ingredients_text"
        case ingredients
        case nutriments
        case ecoscoreGrade = "ecoscore_grade"
        case imageUrl = "image_url"
    }
}

struct Ingredient: Decodable {
    let text: String
}

struct Nutriments: Decodable {
    let energyKcal: Double?
    let fat: Double?
    let saturatedFat: Double?
    let sugars: Double?
    let salt: Double?

    enum CodingKeys: String, CodingKey {
        case energyKcal = "energy-kcal_100g"
        case fat = "fat_100g"
        case saturatedFat = "saturated-fat_100g"
        case sugars = "sugars_100g"
        case salt = "salt_100g"
    }
}

struct ProductDetailsView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Image
                if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Text("No Image Available")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // Product Name
                if let productName = product.productName {
                    Text(productName)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                } else {
                    Text("No Name Available")
                        .font(.title)
                        .bold()
                        .foregroundColor(.gray)
                }

                // Brand
                if let brands = product.brands {
                    Text("Brand: \(brands)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Divider
                Divider()

                // Summary of Key Nutritional Facts
                if let nutriments = product.nutriments {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nutritional Summary")
                            .font(.headline)

                        if let energy = nutriments.energyKcal {
                            Text("Energy: \(energy.rounded(toPlaces: 1)) kcal")
                        }
                        if let fat = nutriments.fat {
                            Text("Fat: \(fat.rounded(toPlaces: 1)) g")
                        }
                        if let sugars = nutriments.sugars {
                            Text("Sugars: \(sugars.rounded(toPlaces: 1)) g")
                        }
                        if let salt = nutriments.salt {
                            Text("Salt: \(salt.rounded(toPlaces: 1)) g")
                        }
                        if let saturatedFat = nutriments.saturatedFat {
                            Text("Saturated Fat: \(saturatedFat.rounded(toPlaces: 1)) g")
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                } else {
                    Text("No Nutritional Facts Available")
                        .foregroundColor(.gray)
                }

                // Navigation Link to Ingredients List
                if let ingredients = product.ingredients {
                    // Use a Set to filter out duplicate ingredient names
                    let uniqueIngredients = Set(ingredients.map { $0.text.lowercased() })
                    let capitalizedIngredients = uniqueIngredients.map { $0.capitalized }.sorted()
                    
                    // Navigate to IngredientsListView
                    NavigationLink(destination: ProductIngredientsListView(ingredients: capitalizedIngredients)) {
                        Text("View Ingredients")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                } else {
                    Text("No Ingredients Available")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .navigationTitle("Product Details")
    }
}
