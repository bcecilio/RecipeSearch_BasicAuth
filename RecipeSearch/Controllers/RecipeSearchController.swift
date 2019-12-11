//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
    // TODO: we need a tableView
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    // TODO: we need recipes array
    // TODO: didSet{} in the recipes array to update the tableView
    var recipeArr = [Recipe]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = "" {
        didSet{
            DispatchQueue.main.async {
                self.searchBarQuery()
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    // TODO: in cellForRow show the recipes label
    // TODO: RecipesSearchAPI.fetchRecipes accessing data to populate ur recipes array (expects a String)
    
    func loadData() {
        RecipeSearchAPI.fetchRecipe(for: "cookies   ") { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("app error: \(appError)")
            case .success(let recipes):
                self?.recipeArr = recipes
            }
        }
    }
    
    func searchBarQuery() {
        RecipeSearchAPI.fetchRecipe(for: searchQuery) { (result) in
            switch result {
            case .failure(let appError):
                print("app error \(appError)")
            case .success(let filteredRecipes):
                self.recipeArr = filteredRecipes.filter{$0.label.lowercased().contains(self.searchQuery.lowercased())}
            }
        }
    }
}

extension RecipeSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        
        let recipeCell = recipeArr[indexPath.row]
        cell.textLabel?.text = recipeCell.label
        return cell
    }
}

extension RecipeSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchBarQuery()
            loadData()
            return
        }
        searchQuery = searchText
    }
}
