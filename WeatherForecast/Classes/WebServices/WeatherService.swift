//
//  File.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/17/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation
import MapKit

protocol WeatherService
{
	func currentWeatherAtLocation(location:CLLocationCoordinate2D, callback:AnyObject -> Void)
	func forecastWeatherAtLocation(location:CLLocationCoordinate2D, callback:[AnyObject] -> Void)
}