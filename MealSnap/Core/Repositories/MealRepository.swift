//
//  MealRepository.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 28/09/25.
//

import UIKit
import CoreData
import Foundation

enum MealAnalysisError: Error, LocalizedError {
    case recognitionFailed
    case nutritionDataNotFound
    case underlying(Error)

    // Mensagens de erro amigáveis para o usuário.
    var errorDescription: String? {
        switch self {
        case .recognitionFailed:
            return NSLocalizedString("error_recognition_failed", comment: "")
        case .nutritionDataNotFound:
            return NSLocalizedString("error_nutrition_not_found", comment: "")
        case .underlying(let error):
            print("Underlying error: \(error.localizedDescription)")
            return NSLocalizedString("error_generic", comment: "")
        }
    }
}

class MealRepository {
    
    private let imageRecognitionService: ImageRecognitionService
    private let nutritionService: NutritionAPIService
    private let context: NSManagedObjectContext
    
    init(imageRecognitionService: ImageRecognitionService, nutritionService: NutritionAPIService, context: NSManagedObjectContext) {
        self.imageRecognitionService = imageRecognitionService
        self.nutritionService = nutritionService
        self.context = context
    }
    
    func saveMeal(_ meal: AnalyzedMeal) throws {
        let newMealEntity = Meal(context: context)
        
        newMealEntity.id = UUID()
        newMealEntity.timestamp = Date()
        newMealEntity.photoData = meal.image.jpegData(compressionQuality: 0.8)
        newMealEntity.identifiedFoods = meal.identifiedFoods.joined(separator: ",")
        
        do {
            try context.save()
            print("Meal saved!")
        } catch {
            throw MealAnalysisError.underlying(error)
        }
    }
    
    func analyzeMeal(from image: UIImage) async throws -> AnalyzedMeal {
        
        let foodNames: [String] = try await withCheckedThrowingContinuation { continuation in
            imageRecognitionService.recognizeFood(in: image) { result in
                switch result {
                case .success(let names):
                    if names.isEmpty {
                        // Se a IA não retornar nada, é um erro de reconhecimento.
                        continuation.resume(throwing: MealAnalysisError.recognitionFailed)
                    } else {
                        continuation.resume(returning: names)
                    }
                case .failure(let error):
                    continuation.resume(throwing: MealAnalysisError.underlying(error))
                }
            }
        }
        
        var nutritionInfo: NutritionInfo?
        if let topFood = foodNames.first {
            
            let query = "1 \(topFood)"
            do {
                nutritionInfo = try await nutritionService.fetchNutrition(for: query)
            } catch {
                print("Error fetching nutrition for'\(query)': \(error)")
            }
        }
        
        
        let analyzedMeal = AnalyzedMeal(
            image: image,
            identifiedFoods: Array(foodNames.prefix(3)),
            nutritionInfo: nutritionInfo
        )
        
        
        return analyzedMeal
    }
    
}
