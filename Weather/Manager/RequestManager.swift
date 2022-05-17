//
//  RequestManager.swift
//  Weather
//
//  Created by Michal Červenec on 26/04/2022.
//

import Foundation
import CoreLocation
import Alamofire

struct RequestManager {
    
    static let shared = RequestManager()
    
    func getWeatherData(for coordinates: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponse, AFError>) -> Void) {

//        let parameters: [String: String] = ["lat": "\(coordinates.latitude)",
//                                            "lon": "\(coordinates.longitude)",
//                                            "exclude": "hourly,minutely,alerts",
//                                            "appid": "7a55c30a1fb98bed4baedf14e2c9476e",
//                                            "units": "metric"]
        
        let request = WeatherRequest(
            latitude: "\(coordinates.latitude)",
            longitude: "\(coordinates.longitude)",
            appId: "7a55c30a1fb98bed4baedf14e2c9476e",
            exclude: "hourly,minutely,alerts",
            units: "metric"
        )

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request)
            .responseDecodable(of: WeatherResponse.self, decoder: decoder) { completion($0.result)
            }
    }
}
