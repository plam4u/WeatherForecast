//
//  TodayViewController.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/15/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import UIKit
import MapKit

class TodayViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		let location = CLLocationCoordinate2DMake(28.030031, -16.594047)
		let weatherService = WeatherServiceOpenWeatherMap()
		weatherService.currentWeatherAtLocation(location)
		{
			weather in
			print(weather)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

