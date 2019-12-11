//
//  RecipeSearchAPITests.swift
//  RecipeSearchTests
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import RecipeSearch

class RecipeSearchAPITests: XCTestCase {
    
    func testSearchChristmasCookies() {
        
        // convert string to a url friendly string
        let searchQuery = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let exp = XCTestExpectation(description: "search not found")
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appkey)"
        
        let request = URLRequest(url: URL(string: recipeEndpointURL)!)
        
        // act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError: \(appError)")
            case .success(let data):
                exp.fulfill()
                // assert
                XCTAssertGreaterThan(data.count, 80000, "data should be greater than \(data.count)")
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    // TODO: write an async test to validate you do get back 50 recipes for the
    // "christmas cookies" search from the getRecipes func
    func testFetchRecipes() {
        let expectedRecipeCount = 50
        let exp = XCTestExpectation(description: "recipes found")
        let searchQuery = "christmas cookies"
        
        RecipeSearchAPI.fetchRecipe(for: searchQuery) { (result) in
            switch result {
            case . failure(let appError):
                XCTFail("app error: \(appError)")
            case .success(let recipes):
                exp.fulfill()
                XCTAssertEqual(recipes.count, expectedRecipeCount)
            }
        }
        
        wait(for: [exp], timeout: 5.0)
    }

}
