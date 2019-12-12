//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var recipeArr = [Recipe]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = ""
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self 
        searchBar.delegate = self
        loadData(searchQuery: "christmas cookies")
        navigationItem.title = "Recipe Search"
    }
    
    func loadData(searchQuery: String) {
        RecipeSearchAPI.fetchRecipe(for: searchQuery) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("app error: \(appError)")
            case .success(let recipes):
                self?.recipeArr = recipes
            }
        }
    }
}

extension RecipeSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCell else {
            fatalError("could not dequeue a recipeCell")
        }
        
        let recipeCell = recipeArr[indexPath.row]
        cell.configureCell(for: recipeCell)
        return cell
    }
}

extension RecipeSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension RecipeSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // here we will use a guard let to unwrap the searchBar.text property because it is an optional.
        guard let searchText = searchBar.text else {
            print("missing search text")
            return
        }
        loadData(searchQuery: searchText)
    }
}
