//
//  DetailedRecipeViewController.swift
//  Food2Fork
//
//  Created by Alexandru Clapa on 11/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SafariServices

class DetailedRecipeViewController: UIViewController, UITableViewDataSource {
	
	@IBOutlet weak var recipeImage: UIImageView?
	@IBOutlet weak var recipeTitle: UILabel?
	@IBOutlet weak var recipePublisher: UILabel?
	@IBOutlet weak var ingredientsTableView: UITableView?
	
	var recipeID = ""
	var recipeDetails = RecipeDetails()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		loadDataForRecipe()
    }
	
	func loadDataForRecipe() {
		RecipeProvider.provideRecipeDetailsForID(recipeID) { (response) in
			self.recipeDetails = response
			self.setupUI()
		}
	}
	
	func setupUI() {
		if let title = recipeDetails.recipeTitle {
			recipeTitle?.text = title
			self.title = title
		}
		
		if let publisher = recipeDetails.recipePublisher {
			recipePublisher?.text = publisher
		}
		
		if let url = recipeDetails.recipeImageURL {
			Alamofire.request(.GET, url)
				.responseImage { response in
					if let image = response.result.value {
						self.recipeImage?.image = image
					}
			}
		}
		
		ingredientsTableView?.reloadData()
	}
	
//	MARK: User Interaction
	
	@IBAction func openRecipeSourceURL() {
		if let url = recipeDetails.recipeSourceURL {
			let svc = SFSafariViewController(URL: NSURL(string: url)!)
			presentViewController(svc, animated: true, completion: nil)
		}
	}
	
//	MARK: UITableView Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			if let ingredients = recipeDetails.ingredients {
				return ingredients.count
			}
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Ingredients"
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "ingredientCell")
		
		cell.textLabel?.text = recipeDetails.ingredients![indexPath.row]
		
		return cell
	}
}
