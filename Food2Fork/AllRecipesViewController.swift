//
//  ViewController.swift
//  Food2Fork
//
//  Created by Alexandru Clapa on 11/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftSpinner

class AllRecipesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView?
	
	var recipes = [Recipe]()
	var lastPageLoaded = 1
	var currentSelectedRowIndex = -1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.tableView!.registerNib(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
		self.title = "All recipes"
		loadFirstPage()
	}
	
//	MARK: Loading Data
	
	func loadFirstPage() {
		SwiftSpinner.show("Loading data...")
		RecipeProvider.provideAllRecipesForPage("1") { (response) in
			self.recipes = response
			self.tableView?.reloadData()
			SwiftSpinner.hide()
		}
	}
	
	func addNextPage() {
		lastPageLoaded += 1
		SwiftSpinner.show("Loading data...")
		RecipeProvider.provideAllRecipesForPage(String(lastPageLoaded)) { (response) in
			self.recipes.appendContentsOf(response)
			self.tableView?.reloadData()
			SwiftSpinner.hide()
		}
	}

//	MARK: UITableView Data Source Methods
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.row == recipes.count - 1 {
			let cell = UITableViewCell.init(style: .Default, reuseIdentifier: "loadMoreCell")
			
			cell.textLabel?.text = "Load more..."
			
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
			
			let currentRecipe = recipes[indexPath.row]
			
			cell.recipeTitle?.text = currentRecipe.title
			cell.recipePublisher?.text = currentRecipe.publisher
			cell.recipeImageView?.image = UIImage(named: "placeholder.png")
			
			if let imageURL = currentRecipe.imageURL {
				Alamofire.request(.GET, imageURL)
					.responseImage { response in
						if let image = response.result.value {
							cell.recipeImageView?.image = image
							cell.recipeImageView?.contentMode = .ScaleAspectFill
							cell.recipeImageView?.clipsToBounds = true
						}
				}
			}
			
			return cell
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = recipes.count
		
		return rows
	}
	
//	MARK: UITableView Delegate Methods
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if indexPath.row == recipes.count - 1 {
			addNextPage()
		} else {
			currentSelectedRowIndex = indexPath.row
			performSegueWithIdentifier("showDetails", sender: nil)
		}
	}
	
//	MARK: Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetails" {
			let destinationVC = segue.destinationViewController as! DetailedRecipeViewController
			destinationVC.recipeID = recipes[currentSelectedRowIndex].id!
		}
	}
	
}

