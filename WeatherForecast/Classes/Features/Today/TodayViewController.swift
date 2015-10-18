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

	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var volumeLabel: UILabel!
	@IBOutlet weak var pressureLabel: UILabel!
	@IBOutlet weak var windSpeedLabel: UILabel!
	@IBOutlet weak var windDirectionLabel: UILabel!
	
	@IBOutlet weak var shareButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		refresh()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "NotificationLocationDidChanged", object: nil)
	}

	func refresh()
	{
//		let location = CLLocationCoordinate2DMake(28.030031, -16.594047)
		if let location = LocationManager.sharedInstance.lastLocation?.coordinate
		{
			WeatherServiceOpenWeatherMap.sharedInstance.currentWeatherAtLocation(location)
				{
					weather in
					print(weather)
					
					self.navigationItem.title = weather.city
					LocationManager.sharedInstance.lastCity = weather.city
					
					self.locationLabel.text = "\(weather.city), \(weather.country)"
					self.temperatureLabel.text = "\(weather.temperature) °C | \(weather.title)"
					self.humidityLabel.text = "\(weather.humidity) %"
					self.volumeLabel.text = "\(weather.rainVolume) mm"
					self.pressureLabel.text = "\(weather.pressure) hPa"
					self.windSpeedLabel.text = "\(weather.windSpeed) m/s"
					self.windDirectionLabel.text = weather.windDirection
					self.weatherImageView.image = UIImage(named: weather.icon)
			}
		}
	}
}

