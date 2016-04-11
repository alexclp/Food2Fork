//
//  RecipeTableViewCell.swift
//  Food2Fork
//
//  Created by Alexandru Clapa on 11/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
	@IBOutlet weak var recipeImageView: UIImageView?
	@IBOutlet weak var recipeTitle: UILabel?
	@IBOutlet weak var recipePublisher: UILabel?
	@IBOutlet weak var recipeIngredients: UITextView?
}
