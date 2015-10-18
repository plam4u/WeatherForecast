//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Plamen Andreev on 10/17/15.
//  Copyright © 2015 Plamen Andreev. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell
{
	@IBOutlet weak var weatherImageView: UIImageView!
	@IBOutlet weak var dayOfWeekLabel: UILabel!
	@IBOutlet weak var weatherTitleLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	
	override func awakeFromNib()
	{
		selectionStyle = UITableViewCellSelectionStyle.None
	}
	
	var forecast:ForecastWeather
	{
		set(newForecast)
		{
			weatherImageView.image = UIImage(named: newForecast.icon)
			weatherTitleLabel.text = "\(newForecast.title)"
			temperatureLabel.text = "\(newForecast.temperature)°"
			dayOfWeekLabel.text = newForecast.day
		}
		
		get
		{
			return self.forecast
		}
	}
}
