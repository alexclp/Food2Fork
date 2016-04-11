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

class AllRecipesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView?
	
	var recipes = [Recipe]()
	var lastPageLoaded = 1
	var currentSelectedRowIndex = -1
	var cellIsTapped = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.tableView!.registerNib(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
		self.title = "All recipes"
		loadFirstPage()
	}
	
//	MARK: Loading Data
	
	func loadFirstPage() {
		RecipeProvider.provideAllRecipesForPage("1") { (response) in
			self.recipes = response
			self.tableView?.reloadData()
		}
	}
	
	func addNextPage() {
		lastPageLoaded += 1
		
		RecipeProvider.provideAllRecipesForPage(String(lastPageLoaded)) { (response) in
			self.recipes.appendContentsOf(response)
			self.tableView?.reloadData()
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

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == currentSelectedRowIndex {
			if cellIsTapped == true {
				cellIsTapped = false
				return 150.0
			} else {
				cellIsTapped = true
				return 80.0
			}
		}
		return 80.0
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
		
		/*else {
			currentSelecteRowIndex = indexPath.row
			cellIsTapped = true
			tableView.beginUpdates()
			tableView.endUpdates()
		}*/
	}
	
//	MARK: Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetails" {
			let destinationVC = segue.destinationViewController as! DetailedRecipeViewController
			destinationVC.recipeID = recipes[currentSelectedRowIndex].id!
		}
	}
	
}

