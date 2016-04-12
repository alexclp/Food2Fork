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
import SwiftSpinner

class DetailedRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var ingredientsTableView: UITableView?
	
	var recipeID = ""
	var recipeDetails = RecipeDetails()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.ingredientsTableView!.registerNib(UINib(nibName: "DetailsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "detailsCell")
		loadDataForRecipe()
    }
	
	func loadDataForRecipe() {
		SwiftSpinner.show("Loading data...")
		RecipeProvider.provideRecipeDetailsForID(recipeID) { (response) in
			self.recipeDetails = response
			self.title = self.recipeDetails.recipeTitle
			self.ingredientsTableView?.reloadData()
			SwiftSpinner.hide()
		}
	}
	
//	MARK: User Interaction
	
	func openRecipeSourceURL() {
		if let url = recipeDetails.recipeSourceURL {
			let svc = SFSafariViewController(URL: NSURL(string: url)!)
			presentViewController(svc, animated: true, completion: nil)
		}
	}
	
//	MARK: UITableView Data Source
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			if let ingredients = recipeDetails.ingredients {
				return ingredients.count + 1
			}
		}
		
		return 0
	}

//	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return "Ingredients"
//	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("detailsCell", forIndexPath: indexPath) as! DetailsHeaderTableViewCell
			
			cell.recipeTitle?.text = recipeDetails.recipeTitle
			cell.recipePublisher?.text = recipeDetails.recipePublisher
			
			Alamofire.request(.GET, recipeDetails.recipeImageURL!)
				.responseImage { response in
					if let image = response.result.value {
						cell.recipeImage!.image = image
					}
			}
			
			cell.recipeSourceButton?.addTarget(self, action: #selector(openRecipeSourceURL), forControlEvents: .TouchUpInside)
			cell.selectionStyle = .None
			
			return cell
		} else {
			let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "ingredientsCell")
			
			cell.textLabel?.text = recipeDetails.ingredients![indexPath.row - 1]
			cell.selectionStyle = .None
			cell.textLabel?.lineBreakMode = .ByWordWrapping
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.font = UIFont(name: "Helvetica", size: 17.0)
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 300.0
		} else {
			return 60.0
		}
	}
}
