//
//  ++.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import Foundation

// Helper Extension for Rounding
extension Double {
    func rounded(toPlaces places: Int) -> String {
        String(format: "%.\(places)f", self)
    }
}
