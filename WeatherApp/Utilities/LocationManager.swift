//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var requestLocationAuthorizationCallback: ((CLAuthorizationStatus, CLLocationCoordinate2D?) -> Void)?

    override init() {
        super.init()
        requestLocationAuthorization()
    }
    
    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        // Only ask authorization if it was never asked before
        guard authorizationStatus == .notDetermined else { return }

        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { (status, _) in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status, manager.location?.coordinate)
    }
}
