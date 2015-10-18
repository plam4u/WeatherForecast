//
//  Constants.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/18/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation

struct Constants
{
	struct Notification
	{
		static let LocationDidChanged = "kLocationManagerLocationDidChanged"
	}
	
	struct Firebase
	{
		static let baseURL = "https://popping-fire-2392.firebaseio.com"
		static let location = "\(baseURL)/location"
		static let currentWeather = "\(baseURL)/currentWeather"
		static let forecastWeather = "\(baseURL)/forecastWeather"
	}
	
	struct WeatherService
	{
		static let baseURL = "http://api.openweathermap.org/data/2.5"
		static let apiKey = "cc58c41e06d028b05470a1acddc81c1e"
		static let units = "metric"
		static let baseParams = "APPID=\(apiKey)&units=\(units)"
		static let currentWeather = "\(baseURL)/weather?\(baseParams)"
		static let forecastWeather = "\(baseURL)/forecast/daily?cnt=7&\(baseParams)"
	}
}

