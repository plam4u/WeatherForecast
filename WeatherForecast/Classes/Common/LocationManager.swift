//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/18/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate
{
	static let sharedInstance = LocationManager()
	var locationManager:CLLocationManager!
	var lastLocation:CLLocation!
	var lastCity:String!
	
	private override init()
	{
		super.init()
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
	}
	
	func startUpdatingLocation()
	{
		locationManager.startUpdatingLocation()
	}
	
	func stopUpdatingLocation()
	{
		locationManager.stopUpdatingLocation()
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		lastLocation = locations[locations.count - 1]
		locationManager.stopUpdatingLocation()
		
		let notification = NSNotification(name: "NotificationLocationDidChanged", object: self, userInfo: ["location":lastLocation])
		NSNotificationCenter.defaultCenter().postNotification(notification)
		print("\(lastLocation.coordinate.latitude) '\(lastLocation.coordinate.longitude)")
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
	{
		// TODO: handle case with location not available
		print(error.description)
	}
}