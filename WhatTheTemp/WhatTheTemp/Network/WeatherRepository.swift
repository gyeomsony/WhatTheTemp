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
        return Single.create { [weak self] observer in
            let disposable = self?.provider.rx.request(.oneCall(lat: lat, lon: lon))
                .map(WeatherResponse.self)
                .subscribe { event in
                    switch event {
                    case .success(let response):
                        return observer(.success(response))
                    case .failure(let error):
                        return observer(.failure(error))
                    }
                }
            guard let disposable = disposable else {
                return Disposables.create()
            }
            return disposable
        }
    }
}
