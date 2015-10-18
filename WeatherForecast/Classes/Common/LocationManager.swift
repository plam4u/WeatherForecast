//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/18/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class LocationManager: NSObject
{
	static let sharedInstance = LocationManager()
	
	var locationManager:CLLocationManager!
	var lastLocation:CLLocationCoordinate2D!
	var lastCity:String!
	
	var locationFirebaseRef:Firebase = Firebase(url:"https://popping-fire-2392.firebaseio.com/location")
	
	private override init()
	{
		super.init()
		
		locationFirebaseRef.observeEventType(.Value)
		{ (snapshot:FDataSnapshot!) -> Void in
			
			debugPrint("Firebase retrieved snapshot: \(snapshot.value)")
			
			if let lat = snapshot.value["lat"] as? Double,
				   lon = snapshot.value["lon"] as? Double
			{
				self.lastLocation = CLLocationCoordinate2DMake(lat, lon)
			}
			
		}
		
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
}

extension LocationManager: CLLocationManagerDelegate
{
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
		lastLocation = locations[locations.count - 1].coordinate
		
		let lastLocationDict = [
			"lat": lastLocation.latitude,
			"lon":lastLocation.longitude
		]
		locationFirebaseRef.setValue(lastLocationDict)
		
		let notification = NSNotification(
			name: Constants.Notification.LocationDidChanged,
			object: self,
			userInfo: ["location":lastLocationDict]
		)
		NSNotificationCenter.defaultCenter().postNotification(notification)
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
	{
		debugPrint(error.description)
	}
}