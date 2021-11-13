//
//  LocationManager.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 10/11/2021.
//

import Foundation
import CoreLocation
import UIKit

class LocManager : NSObject {
    
    static let shared =  LocManager()
    private var locationManager : CLLocationManager?
    
    override init(){
        super.init()
    }
    
      func start(){
        locationManager =  CLLocationManager()
        locationManager?.delegate  = self
        locationManager?.desiredAccuracy = .greatestFiniteMagnitude
        locationManager?.pausesLocationUpdatesAutomatically = true
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func getLastPosition(){
        locationManager?.requestLocation()
    }
    
    deinit{
        locationManager?.stopUpdatingLocation()
    }
}

extension LocManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError", error.localizedDescription)
    }
    
}
