//
//  ViewController.swift
//  Food2Fork
//
//  Created by Alexandru Clapa on 11/04/2016.
//  Copyright © 2016 Alexandru Clapa. All rights reserved.
//

import UIKit

class AllRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

//	MARK: UITableView Data Source Methods
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rows = 0
		
		return rows
	}
	
//	MARK: UITableView Delegate Methods
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
}

