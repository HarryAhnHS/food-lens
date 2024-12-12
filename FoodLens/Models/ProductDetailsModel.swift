//
//  ProductDetailsModel.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation

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

struct Product: Decodable, Identifiable, Hashable {
    var id: String { code } // barcode as unique identifier
    var timestamp: Date? = Date()
    var isSaved: Bool = false
    
    let code: String
    var productName: String? {
        didSet {
            productName = productName?.capitalizedWords() // Auto capitalize using extension
        }
    }
    var brands: String? {
        didSet {
            brands = brands?.capitalizedWords() // Auto capitalize using extension
        }
    }
    let categories: String?
    let labels: String?
    let ingredientsText: String?
    let ingredients: [Ingredient]?
    let allergens: String?
    let origins: String?
    let nutriments: Nutriments?
    let nutriscoreGrade: String?
    let nutriscoreScore: Int?
    let novaGroup: Int?
    let ecoscoreGrade: String?
    let imageUrl: String?
    let servingSize: String?

    // Hashable conform functions
    // Hash:into use barcode val
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    // Implement Equatable conformance for Hashable
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.code == rhs.code
    }

    enum CodingKeys: String, CodingKey {
        case code
        case productName = "product_name"
        case brands
        case categories
        case labels
        case ingredientsText = "ingredients_text"
        case ingredients
        case allergens
        case origins
        case nutriments
        case nutriscoreGrade = "nutriscore_grade"
        case nutriscoreScore = "nutrition-score-fr"
        case novaGroup = "nova-group"
        case ecoscoreGrade = "ecoscore_grade"
        case imageUrl = "image_url"
        case servingSize = "serving_size"
    }
}


struct Ingredient: Decodable {
    var text: String
}
    
struct Nutriments: Decodable {
    let energyKcal: Double?
    let fat: Double?
    let saturatedFat: Double?
    let sugars: Double?
    let salt: Double?
    let fiber: Double?
    let proteins: Double?
    let carbohydrates: Double?
    
    // Nutritional Score custom calculation -> based on average snack standards
    var nutritionalScore: Int {
        var score = 0
        
        if let energy = energyKcal, energy > 200 { score += 1 }
        if let fat = fat, fat > 10 { score += 1 }
        if let sugars = sugars, sugars > 10 { score += 1 }
        if let salt = salt, salt > 1 { score += 1 }
        
        return 5 - score // Higher is healthier (scale: 0-5)
    }
    
    enum CodingKeys: String, CodingKey {
        case energyKcal = "energy-kcal_100g"
        case fat = "fat_100g"
        case saturatedFat = "saturated-fat_100g"
        case sugars = "sugars_100g"
        case salt = "salt_100g"
        case fiber = "fiber_100g"
        case proteins = "proteins_100g"
        case carbohydrates = "carbohydrates_100g"
    }
}
