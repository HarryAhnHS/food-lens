//
//  foodAPI.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation

// Fetch product info using barcode and set Product @stateObject to decoded data
// Async await function using completion @escaping ->
func fetchProductInfo(for barcode: String, completion: @escaping (Product?) -> Void) {
    let API_URL = "https://world.openfoodfacts.org/api/v0/product/"
    guard let url = URL(string: "\(API_URL)\(barcode).json") else {
        print("Invalid API URL")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Failed to fetch data: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }

        do {
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            completion(productResponse.product)
        } catch {
            print("Failed to decode response: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
