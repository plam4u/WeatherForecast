//
//  ForecastViewController.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/15/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.delegate = self;
		tableView.dataSource = self;
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension ForecastViewController : UITableViewDataSource
{
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return 7;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		return cell;
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		return tableView.bounds.size.height / round(tableView.bounds.size.height / 90);
	}
}

extension ForecastViewController : UITableViewDelegate
{
	
}