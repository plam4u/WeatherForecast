//
//  TodayViewController.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/15/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import UIKit
import MapKit
import Firebase

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
		
		refresh()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "NotificationLocationDidChanged", object: nil)
		
		let connectedRef = Firebase(url:"https://popping-fire-2392.firebaseio.com/.info/connected")
		connectedRef.observeEventType(.Value, withBlock: { snapshot in
			let connected = snapshot.value as? Bool
			if connected != nil && connected! {
				print("Connected")
			} else {
				print("Not connected")
			}
		})
	}

	func refresh()
	{
		if let location = LocationManager.sharedInstance.lastLocation
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
	@IBAction func tappedShareButton(sender: AnyObject)
	{
		if let temperature = self.temperatureLabel.text, location = self.locationLabel.text
		{
			let someText:String = "\(temperature) in \(location)"
			let activityViewController = UIActivityViewController(activityItems: [someText], applicationActivities: nil)
			self.navigationController!.presentViewController(activityViewController, animated: true, completion: nil)
		}
		else
		{
			let alert = UIAlertView(title: "Invalid weather conditions", message: "Cannot share right now. Try again later.", delegate: nil, cancelButtonTitle: "OK")
			alert.show()
		}
	}
}

