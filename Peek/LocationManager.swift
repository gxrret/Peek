//
//  LocationManager.swift
//  Peek
//
//  Created by Garret Koontz on 2/2/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit
import MapKit

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    
    var peek: Peek?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func requestCurrentLocation() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}
