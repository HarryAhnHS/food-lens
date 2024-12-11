//
//  UserSearch.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation

// User search object - model for history + saved searches
struct UserSearch: Codable, Identifiable {
    var id: String { barcode } // Use barcode as the unique ID
    let barcode: String
    let timestamp: Date
    var isSaved: Bool
    
    // Helper to write into firebasefirestore
    func toDictionary() -> [String: Any] {
        return [
            "barcode": barcode,
            "isSaved": isSaved,
            "timestamp": timestamp
        ]
    }
}

