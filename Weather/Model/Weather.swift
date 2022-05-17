//
//  Weather.swift
//  Weather
//
//  Created by Michal Červenec on 13/04/2022.
//

import Foundation
import UIKit

enum WeatherSituation {
    
    case sunny
    case cloudy
    case rainy
    
    var icon: UIImage? {
        switch self {
        case .sunny:
            return UIImage(systemName: "sun.max.fill")
        case .cloudy:
            return UIImage(systemName: "cloud.fill")
        case .rainy:
            return UIImage(systemName: "cloud.sun.rain.fill")
        }
    }
}

struct ForecastDay {
    let title: String
    let temperature: Int
    let perception: Int
    let state: WeatherSituation
    
    var tempertureWithCelsius: String {"\(temperature)˚C"}
    var perceptionWithPercentage: String {"\(perception)%"}
    
}
