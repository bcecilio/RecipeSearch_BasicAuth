//
//  RecipeSearchAPI.swift
//  RecipeSearch
//
//  Created by Brendon Cecilio on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct RecipeSearchAPI {
    
    static func fetchRecipe(for searchQuery: String, completion: @escaping (Result<[Recipe], AppError>) -> ()) {
        
        let searchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "tacos"
        
        // using string interoloation to build endpoint url
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appkey)"
        
        // Later we will look at URLComponents and URLQueryItems
        
        guard let url = URL(string: recipeEndpointURL) else {
            completion(.failure(.badURL(recipeEndpointURL)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(RecipeSearch.self, from: data)
                    
                    // use search results to create an array of recipes
                    let recipes = result.hits.map {$0.recipe}
                    // capture the array of recipes in the completion handler
                    completion(.success(recipes))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
