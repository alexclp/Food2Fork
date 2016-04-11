//
//  RecipeProvider.swift
//  Food2Fork
//
//  Created by Alexandru Clapa on 11/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class RecipeProvider: NSObject {
	
	static let basicAllURL = "http://food2fork.com/api/search?key="
	static let basicForIDURL = "http://food2fork.com/api/get?key="
	static let apiKey = "37176991437f37ccf1cc0d18a51739c7"

	class func provideAllRecipesForPage(page: String, completionBlock: ([Recipe]) -> Void)  {
		let urlString = basicAllURL + apiKey + "&page=\(page)"
		
		RecipeServer.sharedServer().GET(urlString) { (response) in
			var parsedRecipes = [Recipe]()
			
			switch response {
				case .Failure(_): print("Failed to fetch data")
				
				case .Success(let data):
					if let json = data as? Dictionary<NSObject, AnyObject> {
						let recipes = json["recipes"] as! [[String : AnyObject]]
						
						for recipe in recipes {
							let current = Recipe()
							current.id = recipe["recipe_id"] as? String
							current.imageURL = recipe["image_url"] as? String
							current.publisher = recipe["publisher"] as? String
							current.title = recipe["title"] as? String
							current.webPageURL = recipe["f2f_url"] as? String
							
							parsedRecipes.append(current)
						}
					}
			}
			completionBlock(parsedRecipes)
		}
	}
}
