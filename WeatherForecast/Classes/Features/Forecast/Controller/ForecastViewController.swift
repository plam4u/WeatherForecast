//
//  ForecastViewController.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/15/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import UIKit
import MapKit

class ForecastViewController: UIViewController
{

	@IBOutlet weak var tableView: UITableView!
	var forecasts:[ForecastWeather] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self;
		tableView.dataSource = self;

		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "fetchWeather",
			name: Constants.Notification.LocationDidChanged,
			object: nil
		)
		
		fetchWeather()
	}

	func fetchWeather()
	{
		self.navigationItem.title = LocationManager.sharedInstance.lastCity
		
		if let location = LocationManager.sharedInstance.lastLocation
		{
			WeatherServiceOpenWeatherMap.sharedInstance.forecastWeatherAtLocation(location)
			{ forecasts in
				
				self.forecasts = forecasts
				self.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension ForecastViewController : UITableViewDataSource
{
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return forecasts.count;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let forecastCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ForecastTableViewCell
		forecastCell.forecast = forecasts[indexPath.row]
		return forecastCell;
	}
}

// MARK: - UITableViewDelegate
extension ForecastViewController : UITableViewDelegate
{
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
	{
		return tableView.bounds.size.height / round(tableView.bounds.size.height / 90);
	}
}