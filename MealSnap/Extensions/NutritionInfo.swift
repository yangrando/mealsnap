//
//  NutritionInfo.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import Foundation

extension NutritionInfo {
    // Customizamos a decodificação para pegar os valores que queremos.
    private enum CodingKeys: String, CodingKey {
        case nutrients
    }
    
    private struct Nutrient: Codable {
        let name: String
        let amount: Double
        let unit: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nutrients = try container.decode([Nutrient].self, forKey: .nutrients)
        
        // Função auxiliar para encontrar um nutriente e formatar a string.
        func findNutrient(_ name: String) -> String {
            if let nutrient = nutrients.first(where: { $0.name.lowercased() == name.lowercased() }) {
                return "\(nutrient.amount) \(nutrient.unit)"
            }
            return "N/A"
        }
        
        calories = findNutrient("calories")
        carbs = findNutrient("carbohydrates")
        fat = findNutrient("fat")
        protein = findNutrient("protein")
    }
}
