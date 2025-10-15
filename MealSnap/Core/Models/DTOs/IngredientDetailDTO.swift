//
//  IngredientDetailDTO.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import Foundation

struct IngredientDetail: Decodable {
    let id: Int
    let name: String
    let amount: Double
    let unit: String
    let nutrition: NutritionInfo
}
