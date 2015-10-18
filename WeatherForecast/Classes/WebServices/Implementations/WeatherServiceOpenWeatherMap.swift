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
	
	let currentWeatherFirebaseRef:Firebase = Firebase(url:"https://popping-fire-2392.firebaseio.com/currentWeather")
	let forecastWeatherFirebaseRef:Firebase = Firebase(url:"https://popping-fire-2392.firebaseio.com/forecastWeather")
	
	var units = "metric"
	var apiKey = "cc58c41e06d028b05470a1acddc81c1e"
	
	private init()
	{
		currentWeatherFirebaseRef.observeEventType(.Value, withBlock: { snapshot in
			print(snapshot.value)
			}, withCancelBlock: { error in
				print(error.description)
		})
	}
	
	func currentWeatherAtLocation(location:CLLocationCoordinate2D, callback:CurrentWeather -> Void)
	{
		print("currentWeatherAtLocation")
		
		
		currentWeatherFirebaseRef.observeEventType(.Value)
			{ (snapshot:FDataSnapshot!) -> Void in
				
				print("retrieved current weather")
				if let weatherDict = snapshot.value
				{
					let currentWeather = CurrentWeather(
						title: weatherDict["title"]! as! String,
						city: weatherDict["city"]! as! String,
						country: weatherDict["country"]! as! String,
						temperature: weatherDict["temperature"]! as! Int,
						humidity: weatherDict["humidity"]! as! Int,
						rainVolume: weatherDict["rainVolume"]! as! Int,
						pressure: weatherDict["pressure"]! as! Int,
						windSpeed: weatherDict["windSpeed"]! as! Int,
						windDirection: weatherDict["windDirection"]! as! String,
						icon: weatherDict["icon"]! as! String
					)
					callback(currentWeather)
				}
				else
				{
					print("current weather firebase failed")
				}
		}

		Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=&APPID=\(apiKey)&units=\(units)").responseJSON
		{ response in

			if let jsonResult = response.result.value
			{
				let json = JSON(jsonResult)
//				print("SwiftyJSON \(json)")
				let locale = NSLocale.systemLocale()
				let country = locale.displayNameForKey(NSLocaleCountryCode, value: json["sys"]["country"].stringValue)!
				let windDirection = self.windDirectionFromDegrees(json["wind"]["deg"].intValue)
				
				let weatherDict = [
					"title": json["weather", 0, "main"].stringValue,
					"city": json["name"].stringValue,
					"country": country,
					"temperature": json["main", "temp"].intValue,
					"humidity": json["main", "humidity"].intValue,
					"rainVolume": json["rain"]["3h"].intValue,
					"pressure": json["main", "pressure"].intValue,
					"windSpeed": json["wind", "speed"].intValue,
					"windDirection": windDirection,
					"icon": self.weatherImageForDescription(json["weather", 0, "main"].stringValue)
				]
				print("setValue current weather")
				self.currentWeatherFirebaseRef.setValue(weatherDict)
			}
		}
	}
	
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[ForecastWeather] -> Void)
	{
		forecastWeatherFirebaseRef.observeEventType(.Value)
		{ (snapshot:FDataSnapshot!) -> Void in
			
			print("retrieved forecast weather")
			if let forecasts = snapshot.value as? [AnyObject!]
			{
//					var forecastResult:[ForecastWeather] = []
				
				var forecastResult:[ForecastWeather] = []
				
				for forecast in forecasts
				{
					if let forecastDict = forecast as? [String:AnyObject!]
					{
						print(forecastDict["a"])
						
						let forecast = ForecastWeather(
							title: forecastDict["title"]! as! String,
							temperature: forecastDict["temperature"]! as! Int,
							day: forecastDict["day"]! as! String,
							icon: forecastDict["icon"]! as! String
						)
						forecastResult.append(forecast)
					}
				}
					callback(forecastResult)
			}
			else
			{
				print("forecast weather firebase failed")
			}
		}
		
		
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast/daily?cnt=7&lat=\(location.latitude)&lon=\(location.longitude)&units=&APPID=\(apiKey)&units=\(units)").responseJSON
        { response in
			
			if let jsonResult = response.result.value
			{
				let json = JSON(jsonResult)
				print("SwiftyJSON \(json)")
				
				let dateFormatter = NSDateFormatter()
				dateFormatter.dateFormat = "EEEE"
				var forecastResult = Array<Dictionary<String, AnyObject!>>()

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
				
				self.forecastWeatherFirebaseRef.setValue(forecastResult)
				
//				callback(forecastResult)
			}
        }
	}

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