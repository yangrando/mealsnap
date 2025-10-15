//
//  NutritionAPIService.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}


final class NutritionAPIService {
    
    private let apiKey = APIKeyManager.getSpoonacularAPIKey()
    private let baseURL = "https://api.spoonacular.com"
    
    func fetchNutrition(for query: String) async throws -> NutritionInfo {
            // 1. Montar a URL com os parâmetros necessários.
            var components = URLComponents(string: "\(baseURL)/recipes/parseIngredients")
            components?.queryItems = [
                URLQueryItem(name: "ingredientList", value: query),
                URLQueryItem(name: "servings", value: "1"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            guard let url = components?.url else {
                throw NetworkError.invalidURL
            }
            
            // 2. Fazer a chamada de rede usando async/await.
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // 3. Validar a resposta do servidor.
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            // 4. Decodificar a resposta JSON para nossas estruturas Swift.
            // A API retorna um array, então pegamos o primeiro item.
            do {
                let ingredients = try JSONDecoder( ).decode([IngredientDetail].self, from: data)
                guard let firstIngredient = ingredients.first else {
                    throw NetworkError.decodingFailed(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Array de ingredientes vazio"]))
                }
                return firstIngredient.nutrition
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        }
}



