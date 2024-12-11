//
//  NutritionalItem.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

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
