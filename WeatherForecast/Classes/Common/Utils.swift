//
//  Utils.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/18/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import Foundation

func debugPrint(message: String, function: String = __FUNCTION__, file: String = __FILE__)
{
	#if DEBUG
		let fileName = (file.componentsSeparatedByString("/").last)
		let fileNameWithoutExtension = fileName?.componentsSeparatedByString(".").first
		print("\(fileNameWithoutExtension!).\(function): \(message)")
	#endif
}

extension Int {
	func format(f: String) -> String {
		return NSString(format: "%\(f)d", self) as String
	}
}

extension Double {
	func format(f: String) -> String {
		return NSString(format: "%\(f)f", self) as String
	}
}