//
//  ProductDetailsModel.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

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
