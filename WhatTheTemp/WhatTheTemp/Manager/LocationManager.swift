//
//  LocationManager.swift
//  WhatTheTemp
//
//  Created by EMILY on 08/01/2025.
//

import CoreLocation

class LocationManager: NSObject {
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return manager
    }()
    
    var currentLocation: CLLocation? {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:   // 위치 정보 수집 허용 시 : 사용자 위치 반환
            locationManager.location
        default:                                          // 위치 정보 수집 불허용/미허용 상태 : 서울시청 위치 반환
            CLLocation(latitude: 37.5665851, longitude: 126.9782038)
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

/// 디버깅용
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let currentLocation = currentLocation else { return }
        print(currentLocation)
    }
}
