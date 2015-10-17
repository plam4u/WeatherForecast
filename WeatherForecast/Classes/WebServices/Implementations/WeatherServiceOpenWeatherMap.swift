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

class WeatherServiceOpenWeatherMap: WeatherService
{
	var units = "metric"
	var apiKey = "cc58c41e06d028b05470a1acddc81c1e"
	
	func currentWeatherAtLocation(location:CLLocationCoordinate2D, callback:CurrentWeather -> Void)
	{
		Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=&APPID=\(apiKey)&units=\(units)").responseJSON
		{ response in

			let json = JSON(response.result.value!)
			let locale = NSLocale.systemLocale()
			let country = locale.displayNameForKey(NSLocaleCountryCode, value: json["sys"]["country"].stringValue)!
			let windDirection = self.windDirectionFromDegrees(json["wind"]["deg"].intValue)
			let currentWeather = CurrentWeather(
				title: json["weather", 0, "main"].stringValue,
				city: json["name"].stringValue,
				country: country,
				temperature: json["main", "temp"].intValue,
				humidity: json["main", "humidity"].intValue,
				rainVolume: json["rain"]["3h"].intValue,
				pressure: json["main", "pressure"].intValue,
				windSpeed: json["wind", "speed"].intValue,
				windDirection: windDirection,
				icon: self.weatherImageForDescription(json["weather", 0, "main"].stringValue)
			)
//			print("SwiftyJSON \(json)")
			callback(currentWeather)
		}
	}
	
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[ForecastWeather] -> Void)
	{
        Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/forecast/daily?cnt=7&lat=\(location.latitude)&lon=\(location.longitude)&units=&APPID=\(apiKey)&units=\(units)").responseJSON
        { response in

			var forecastResult:[ForecastWeather] = []
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "EEEE"
			let json = JSON(response.result.value!)
			print("SwiftyJSON \(json)")

			if let daysCount = json["cnt"].int
			{
				for index in 0..<daysCount
				{
					let current = json["list"][index]
					let date = NSDate(timeIntervalSince1970: NSTimeInterval(current["dt"].intValue))
					let dayOfWeekString = dateFormatter.stringFromDate(date)
					let forecast = ForecastWeather(
						title: current["weather", 0, "main"].stringValue,
								temperature: current["temp", "day"].intValue,
								day: dayOfWeekString,
								icon: self.weatherImageForDescription(current["weather", 0, "main"].stringValue)
					)
					forecastResult.append(forecast)
				}
			}
			callback(forecastResult)
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
        case let (x) where x >= 338 && x < 24:
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