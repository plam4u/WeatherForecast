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
				let sys = JSON["sys"] as! NSDictionary

				let country = NSLocale.systemLocale().displayNameForKey(NSLocaleCountryCode, value:sys["country"] as! String)!
                let windDirection = self.windDirectionFromDegrees(wind["deg"] as! Int)

				let currentWeather = CurrentWeather(
					title: weather["main"] as! String,
					city: JSON["name"] as! String,
					country:country,
					temperature: main["temp"] as! Int,
					humidity: main["humidity"] as! Int,
					rainVolume: 0,
					pressure: main["pressure"] as! Int,
					windSpeed: wind["speed"] as! Int,
					windDirection: windDirection,
					icon:self.weatherImageForDescription(weather["description"] as! String)
				)
				callback(currentWeather)
			}
		}
	}
	
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[ForecastWeather] -> Void)
	{
		
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

    func weatherImageForDescription(description:String) -> String
    {
        switch (description)
        {
            case "few clouds", "scattered clouds", "broken clouds":
                return "Cloudy_Big"
            case "shower rain", "rain", "thunderstorm", "snow":
                return "Lightning_Big"
            case "mist":
                return "Wind_Big"
            default:
                return "Sun_Big"
        }
    }
}