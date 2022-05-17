//
//  WeatherRequest.swift
//  Weather
//
//  Created by Michal Červenec on 26/04/2022.
//

import Foundation

struct WeatherRequest: Encodable {
    
    let latitude: String
    let longitude: String
    let appId: String
    let exclude: String
    let units: String
    
    enum CodingKeys: String, CodingKey {
        
        case latitude = "lat"
        case longitude = "lon"
        case appId = "appid"
        case exclude, units
    }
}
