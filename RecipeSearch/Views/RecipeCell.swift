//
//  RecipeCell.swift
//  RecipeSearch
//
//  Created by Brendon Cecilio on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    func configureCell(for recipe: Recipe) {
        recipeLabel.text = recipe.label
        recipeImageView.getImage(with: recipe.image) { [weak self] (result) in
            switch result {
            case .failure( _):
                DispatchQueue.main.async {
                    self?.recipeImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            case .success(let image):
                // this is the global() thread (background)
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                }
            }
        }
    }
}
