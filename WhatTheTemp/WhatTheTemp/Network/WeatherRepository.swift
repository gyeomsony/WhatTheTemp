//
//  WeatherRepository.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/9/25.
//

import Foundation
import RxMoya
import Moya

final class WeatherRepository {
    private let provider = MoyaProvider<WeatherAPI>()
    
    func fetchWeather() {
        provider.rx.request(.oneCall(lat: 37.5665851, lon: 126.9782038))
            .subscribe { event in
                switch event {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
