//
//  WeatherRepository.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/9/25.
//

import Foundation
import RxMoya
import Moya
import RxSwift

protocol WeatherRepositoryProtocol {
    // OpenWeather API
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse>
    
    // Visual Crossing API
    func fetchVXCWeatherData(location: String, startDate: String, endDate: String) -> Single<VXCWeatherResponse>
}

final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = MoyaProvider<WeatherAPI>()
    
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse> {
        return provider.rx.request(.oneCall(lat: lat, lon: lon))
            .map(WeatherResponse.self)
    }
    
    
    func fetchVXCWeatherData(location: String, startDate: String, endDate: String) -> Single<VXCWeatherResponse> {
        return provider.rx.request(.visualCrossing(location: location, startDate: startDate, endDate: endDate))
            .map(VXCWeatherResponse.self)
    }
}
