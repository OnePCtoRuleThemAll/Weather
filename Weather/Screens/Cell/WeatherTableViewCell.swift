//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Michal Červenec on 06/04/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    //MARK: - Static
    static var classString: String {String(describing: Self.self)}
    
    //MARK: - Otlets
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
}

//MARK: - Public

extension WeatherTableViewCell {
    
    func setupCell(with day: DailyWeather) {     
        dayLabel.text = DateFormatter.dayDateFormatter.string(from: day.date)
        weatherIcon.image = day.weather.first?.image?.withRenderingMode(.alwaysOriginal)
        percentageLabel.text = day.formattedPercipitation
        temperatureLabel.text = day.temperature.temperatureWithCelsius
    }
}
