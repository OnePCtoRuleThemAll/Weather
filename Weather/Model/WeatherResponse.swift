//
//  MyWeatherResponse.swift
//  Weather
//
//  Created by Michal Červenec on 26/04/2022.
//

import Foundation
import UIKit

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {

    let current: CurrentWeather
    let days: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case days = "daily"
        case current
    }
}

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    
    let date: Date
    let temperature: Double
    let feelsLike: Double
    let weather: [Weather]

    var temperatureWithCelsius: String { "\(Int(temperature))˚C" }
    var feelsLikeWithCelsius: String { "Feels like \(Int(feelsLike))˚C" }
    
    enum CodingKeys: String, CodingKey {
        
        case date = "dt"
        case feelsLike = "feels_like"
        case temperature = "temp"
        case weather
    }
}

// MARK: - DailyWeather
struct DailyWeather: Decodable {
    
    let date: Date
    let temperature: Temperature
    let weather: [Weather]
    let precipitation: Double

    var formattedPercipitation: String { "\(Int(precipitation * 100))%"}
    enum CodingKeys: String, CodingKey {
        
        case date = "dt"
        case temperature = "temp"
        case precipitation = "pop"
        case weather
    }
}

// MARK: - Weather
struct Weather: Decodable {
    
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        
        case description = "main"
        case icon
    }
    
    var image: UIImage? {
        switch icon {
        case "03d":
            return UIImage(systemName: "cloud.fill")
        case "04d":
            return UIImage(systemName: "cloud.fill")
        case "11d":
            return UIImage(systemName: "cloud.bolt.fill")
        case "09d":
            return UIImage(systemName: "cloud.drizzle.fill")
        case "10d":
            return UIImage(systemName: "cloud.rain.fill")
        case "13d":
            return UIImage(systemName: "cloud.snow.fill")
        case "50d":
            return UIImage(systemName: "smoke.fill")
        case "01d":
            return UIImage(systemName: "sun.max.fill")
        case "02d":
            return UIImage(systemName: "cloud.sun.fill")
        default:
            return UIImage(systemName: "moon.circle.fill")
        }
    }
}

// MARK: - Temperature
struct Temperature: Decodable {
    
    let day: Double
    
    var temperatureWithCelsius: String { "\(Int(day))˚C" }

}
