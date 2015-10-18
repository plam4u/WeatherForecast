//
//  OpenWeatherMapUtils.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/18/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

extension WeatherServiceOpenWeatherMap
{
	func currentWeatherURLForLocation(location:CLLocationCoordinate2D) -> String
	{
		return "\(Constants.WeatherService.currentWeather)&lat=\(location.latitude)&lon=\(location.longitude)"
	}
	
	func forecastWeatherURLForLocation(location:CLLocationCoordinate2D) -> String
	{
		return "\(Constants.WeatherService.forecastWeather)&lat=\(location.latitude)&lon=\(location.longitude)"
	}
	
	func convertWeatherDictToCurrentWeather(dict:[String:AnyObject!]) -> CurrentWeather
	{
		return CurrentWeather(
			title: dict["title"]! as! String,
			city: dict["city"]! as! String,
			country: dict["country"]! as! String,
			temperature: dict["temperature"]! as! Int,
			humidity: dict["humidity"]! as! Int,
			rainVolume: dict["rainVolume"]! as! Double,
			pressure: dict["pressure"]! as! Int,
			windSpeed: dict["windSpeed"]! as! Int,
			windDirection: dict["windDirection"]! as! String,
			icon: dict["icon"]! as! String
		)
	}
	
	func parseCurrentWeatherJSON(json:JSON) -> [String:AnyObject!]
	{
		let locale = NSLocale.systemLocale()
		let country = locale.displayNameForKey(NSLocaleCountryCode, value: json["sys"]["country"].stringValue)!
		let windDirection = self.windDirectionFromDegrees(json["wind"]["deg"].intValue)
		
		return [
			"title": json["weather", 0, "main"].stringValue,
			"city": json["name"].stringValue,
			"country": country,
			"temperature": json["main", "temp"].intValue,
			"humidity": json["main", "humidity"].intValue,
			"rainVolume": json["rain"]["3h"].doubleValue,
			"pressure": json["main", "pressure"].intValue,
			"windSpeed": json["wind", "speed"].intValue,
			"windDirection": windDirection,
			"icon": self.weatherImageForDescription(json["weather", 0, "main"].stringValue)
		]
	}
	
	func convertForecastDictsToForecastObjects(forecasts:[[String:AnyObject!]]) -> [ForecastWeather]
	{
		var forecastResult:[ForecastWeather] = []
		
		for forecastDict in forecasts
		{
			let forecast = ForecastWeather(
				title: forecastDict["title"]! as! String,
				temperature: forecastDict["temperature"]! as! Int,
				day: forecastDict["day"]! as! String,
				icon: forecastDict["icon"]! as! String
			)
			forecastResult.append(forecast)
		}
		return forecastResult
	}
	
	func parseForecastWeatherJSON(json:JSON) -> [[String:AnyObject!]]
	{
		var forecastResult = [[String:AnyObject!]]()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE"
		
		if let daysCount = json["cnt"].int
		{
			for index in 0..<daysCount
			{
				let current = json["list"][index]
				let date = NSDate(timeIntervalSince1970: NSTimeInterval(current["dt"].intValue))
				let dayOfWeekString = dateFormatter.stringFromDate(date)
				
				let dict:[String:AnyObject!] =
				[
					"title": current["weather", 0, "main"].stringValue,
					"temperature": current["temp", "day"].intValue,
					"day": dayOfWeekString,
					"icon": self.weatherImageForDescription(current["weather", 0, "main"].stringValue)
				]
				forecastResult.append(dict)
			}
		}
		return forecastResult
	}
	
	// TODO: convert to enum
	func windDirectionFromDegrees(var degrees:Int) -> String
	{
		if(degrees < 0)
		{
			degrees += 360
		}
		
		switch (degrees)
		{
		case 338...360, 0..<24:
			return "N"
		case 24 ..< 68:
			return "NE"
		case 68 ..< 113:
			return "E"
		case 113 ..< 158:
			return "SE"
		case 158..<203:
			return "S"
		case 203..<248:
			return "SW"
		case 248..<293:
			return "W"
		case 293..<338:
			return "NW"
		default:
			return ""
		}
	}
	
	// TODO: convert to enum
	func weatherImageForDescription(key:String) -> String
	{
		switch (key)
		{
		case "Clouds":
			return "Cloudy_Big"
		case "Thunderstorm", "Rain", "Drizzle", "Snow", "Atmosphere":
			return "Lightning_Big"
		case "Extreme", "Additional":
			return "Wind_Big"
		default:
			return "Sun_Big"
		}
	}
}