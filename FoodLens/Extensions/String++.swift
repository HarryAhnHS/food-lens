//
//  String++.swift
//  FoodLens
//
//  Created by Harry Ahn on 11/12/2024.
//

import Foundation

// Extension to capitalize each word in a string 
extension String {
    func capitalizedWords() -> String {
        return self.split(separator: " ").map { $0.capitalized }.joined(separator: " ")
    }
}
