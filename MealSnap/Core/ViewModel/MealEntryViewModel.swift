//
//  MealEntryViewModel.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 27/09/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine


enum ViewState {
    case idle
    case loading
    case success(AnalyzedMeal)
    case saved
    case error(String)
}

@MainActor
class MealEntryViewModel: ObservableObject {
    
    @Published var capturedImage: UIImage?
    @Published var viewState: ViewState = .idle
    
    private let mealRepository: MealRepository
    
    init(context: NSManagedObjectContext) {
        let imageService = ImageRecognitionService()
        let nutritionService = NutritionAPIService()
        
        self.mealRepository = MealRepository(
            imageRecognitionService: imageService,
            nutritionService: nutritionService,
            context: context
        )
    }
    
    func analyzeImage() {

        guard let image = self.capturedImage else {
            viewState = .error("Nenhuma imagem para analisar.")
            return
        }
        
        
        
        viewState = .loading
        
        Task {
            do {
                // A chamada agora é para o repositório, muito mais limpa!
                let meal = try await mealRepository.analyzeMeal(from: image)
                viewState = .success(meal)
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }
    }
    
    func save() {
        guard case .success(let meal) = viewState else {
            return
        }
        
        do {
            try mealRepository.saveMeal(meal)
            viewState = .saved
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
    
    func resetState() {
        viewState = .idle
    }
    
    func clearAll() {
        print("🗑️ [MealEntryViewModel] clearAll() chamado")
        viewState = .idle
        capturedImage = nil
    }
}
