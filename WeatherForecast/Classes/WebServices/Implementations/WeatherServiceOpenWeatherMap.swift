//
//  WeatherServiceOpenWeatherMap.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/17/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON
import Firebase

class WeatherServiceOpenWeatherMap: WeatherService
{
	static let sharedInstance = WeatherServiceOpenWeatherMap()
	
	let currentWeatherFirebaseRef:Firebase = Firebase(url:Constants.Firebase.currentWeather)
	let forecastWeatherFirebaseRef:Firebase = Firebase(url:Constants.Firebase.forecastWeather)
	
	func currentWeatherAtLocation(location:CLLocationCoordinate2D, callback:CurrentWeather -> Void)
	{
		Alamofire.request(.GET, currentWeatherURLForLocation(location)).responseJSON
		{
			response in

			if let jsonResult = response.result.value
			{
				let json = JSON(jsonResult)
				let weatherDict = self.parseCurrentWeatherJSON(json)
				self.currentWeatherFirebaseRef.setValue(weatherDict)
			}
		}
		
		currentWeatherFirebaseRef.observeEventType(.Value)
			{
				(snapshot:FDataSnapshot!) -> Void in
				
				if let weatherDict = snapshot.value as? [String:AnyObject!]
				{
					callback(self.convertWeatherDictToCurrentWeather(weatherDict))
				}
		}
	}
	
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[ForecastWeather] -> Void)
	{
		Alamofire.request(.GET, forecastWeatherURLForLocation(location)).responseJSON
        {
			response in
			
			if let jsonResult = response.result.value
			{
				let json = JSON(jsonResult)
				let forecasts = self.parseForecastWeatherJSON(json)
				self.forecastWeatherFirebaseRef.setValue(forecasts)
			}
        }
		
		forecastWeatherFirebaseRef.observeEventType(.Value)
		{
			(snapshot:FDataSnapshot!) -> Void in
			
			if let forecasts = snapshot.value as? [[String:AnyObject!]]
			{
				callback(self.convertForecastDictsToForecastObjects(forecasts))
			}
		}
	}
}