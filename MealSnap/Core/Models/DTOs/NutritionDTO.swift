//
//  NutritionDTO.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import Foundation

struct NutritionInfo: Decodable {
    let calories: String
    let carbs: String
    let fat: String
    let protein: String
}
