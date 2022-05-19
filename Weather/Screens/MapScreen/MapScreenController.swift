//
//  MapScreenController.swift
//  Weather
//
//  Created by Michal Červenec on 19/05/2022.
//

import UIKit
import MapKit

class MapScreenController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 49.3, longitude: 19.6)
        mapView.centerToLocation(initialLocation)
    }
}

private extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionradius: CLLocationDistance = 500000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionradius, longitudinalMeters: regionradius)
        setRegion(coordinateRegion, animated: true)
    }
}
