//
//  GeocoderViewController.swift
//  Fork Authority iOS
//
//  Created by Chi-Ying Leung on 5/29/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import CoreLocation

class GeocoderViewController: BusinessController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()  // changed from requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // stop trying to find location after didUpdateLocation is called once
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(latestLocation) { [weak self] (placemarks, error) in
 
            if let error = error {
                print("Failed to reverse geocode from coordinates", error)
                return
            }
            if let placemark = placemarks?.last {

                guard let name = placemark.name else {
                    print("Failed to find location name for:", placemark)
                    return
                }

                let state = placemark.addressDictionary?["State"] as? String
                let zip = placemark.addressDictionary?["ZIP"] as? String
                
                self?.location = Location(coordinate: latestLocation.coordinate, name: name, state: state, zip: zip)
                
                
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // handle error here
    }
    
}

