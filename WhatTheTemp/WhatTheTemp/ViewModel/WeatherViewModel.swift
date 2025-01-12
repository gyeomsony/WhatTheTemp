//
//  WeatherViewModel.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/12/25.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    private let repository: WeatherRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    let currentWeather = PublishRelay<Current>()
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchWeatherResponse(lat: Double, lon: Double) {
        repository.fetchWeather(lat: lat, lon: lon)
            .subscribe(onSuccess: { [weak self] (response: WeatherResponse) in
                let current = Current(weatherDescription: response.currentWeather.weather[0].description,
                                      currentTemperature: response.currentWeather.temperature,
                                      weatherCode: response.currentWeather.weather[0].code,
                                      feelsLikeTemperature: response.currentWeather.feelsLike,
                                      minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                      maxTemperature: response.dailyWeather[0].temperature.maxTemperature,
                                      windSpeed: response.currentWeather.windSpeed,
                                      humidity: response.currentWeather.humidity,
                                      rainProbability: response.hourlyWeather[0].rain)
                self?.currentWeather.accept(current)
            }, onFailure: { error in
                print("에러 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
