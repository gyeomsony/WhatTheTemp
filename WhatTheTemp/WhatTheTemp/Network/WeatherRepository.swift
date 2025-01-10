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
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse>
}

final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = MoyaProvider<WeatherAPI>()
    
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse> {
        return provider.rx.request(.oneCall(lat: lat, lon: lon))
            .map(WeatherResponse.self)
    }
}
