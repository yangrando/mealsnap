//
//  APIKeyManager.swift
//  MealSnap
//
//  Created by Yan Felipe Grando on 24/09/25.
//

import Foundation

enum APIKeyManager {
    static func getSpoonacularAPIKey() -> String {
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
            fatalError("Não foi possível encontrar o arquivo 'ApiKeys.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "SpoonacularAPIKey") as? String else {
            fatalError("Não foi possível encontrar a chave 'SpoonacularAPIKey' no arquivo 'ApiKeys.plist'.")
        }
        
        if value.starts(with: "SUA_CHAVE_AQUI") || value.isEmpty {
            fatalError("A chave da API da Spoonacular não foi definida no arquivo ApiKeys.plist. Por favor, adicione sua chave.")
        }
        
        return value
    }
}
