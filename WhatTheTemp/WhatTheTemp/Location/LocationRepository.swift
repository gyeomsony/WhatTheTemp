//
//  LocationRepository.swift
//  WhatTheTemp
//
//  Created by EMILY on 08/01/2025.
//

import CoreLocation
import RxCocoa

protocol LocationRepositoryProtocol {
    var currentCityName: BehaviorRelay<String> { get }
    var authorizationUpdated: PublishRelay<Void> { get }
    var currentLocation: CLLocation? { get }
}

class LocationRepository: NSObject, LocationRepositoryProtocol {
    
    let currentCityName = BehaviorRelay<String>(value: "서울시")
    let authorizationUpdated = PublishRelay<Void>()
    
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
    
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

extension LocationRepository: CLLocationManagerDelegate {
    /// 위치 정보 수집 권한이 변경될 때마다 호출되는 메소드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        /// 사용자가 동의했을 때 : 사용자 좌표의 행정구역을 relay에 방출, 권한 변경 이벤트 방출
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationUpdated.accept(())
            guard let currentLocation = currentLocation else { return }
            geocoder.reverseGeocodeLocation(currentLocation) { [weak self] placemarks, error in
                guard let cityName = placemarks?.first?.administrativeArea else { return }
                self?.currentCityName.accept(cityName)
            }
        /// 사용자가 동의를 안한 상황(미선택, 거절, 제한 등) : 어차피 currentLocation의 기본값인 서울시청 좌표를 사용할 거기 때문에 이벤트만 방출
        default:
            authorizationUpdated.accept(())
        }
    }
}
