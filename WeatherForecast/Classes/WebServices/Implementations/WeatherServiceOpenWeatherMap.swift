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

class WeatherServiceOpenWeatherMap: WeatherService
{
	var units = "metric"
	var apiKey = "cc58c41e06d028b05470a1acddc81c1e"
	
	func currentWeatherAtLocation(location:CLLocationCoordinate2D, callback:CurrentWeather -> Void)
	{
		Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=&APPID=\(apiKey)&units=\(units)").responseJSON
		{ response in
			
			if let JSON = response.result.value
			{
				print(JSON)
				let weather = (JSON["weather"] as! NSArray)[0] as! NSDictionary
				let main = JSON["main"] as! NSDictionary
				let wind = JSON["wind"] as! NSDictionary
				
				let currentWeather = CurrentWeather(
					title: weather["main"] as! String,
					cityName: JSON["name"] as! String,
					temperature: main["temp"] as! Int,
					humidity: main["humidity"] as! Int,
					rainVolume: 0,
					pressure: main["pressure"] as! Int,
					windSpeed: wind["speed"] as! Int,
					windDirectionDeg: wind["deg"] as! Int,
					icon:""
				)
				callback(currentWeather)
			}
		}
	}
	
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[ForecastWeather] -> Void)
	{
		
	}
}