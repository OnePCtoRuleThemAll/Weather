//
//  LocationManager.swift
//  Weather
//
//  Created by Michal Červenec on 13/04/2022.
//

import Foundation
import CoreLocation

struct CurrentLocation {
    
    let city: String
    let coordinates: CLLocationCoordinate2D
}

typealias CityCompletionHandler = ((CurrentLocation?, Error?) -> Void)

class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    private var geocoder = CLGeocoder()
    
    var completion: CityCompletionHandler?
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else {return}
            
            guard let placemark = placemarks?.first, let city = placemark.locality, error == nil
                else {
                if let completion = self.completion {
                    completion(nil, error)
                }
                return
            }
            let currentLocation = CurrentLocation(city: city, coordinates: location.coordinate)
            self.completion?(currentLocation, nil)
            print(city)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied:
            print("denied")
        case .authorizedWhenInUse, .authorizedAlways:
            print("authorized")
        case .notDetermined:
            print("not yet")
        case .restricted:
            print("restricted")
        @unknown default:
            fatalError()
        }
    }
}
