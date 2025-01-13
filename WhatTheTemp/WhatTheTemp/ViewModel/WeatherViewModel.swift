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
    let hourlyWeather = PublishRelay<[WeatherSummary]>()
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchWeatherResponse(lat: Double, lon: Double) {
        repository.fetchWeather(lat: lat, lon: lon)
            .map { response -> (Current, [WeatherSummary] ) in
                let current = Current(weatherDescription: response.currentWeather.weather[0].description,
                                      currentTemperature: response.currentWeather.temperature,
                                      weatherCode: response.currentWeather.weather[0].code,
                                      feelsLikeTemperature: response.currentWeather.feelsLike,
                                      minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                      maxTemperature: response.dailyWeather[0].temperature.maxTemperature,
                                      windSpeed: response.currentWeather.windSpeed,
                                      humidity: response.currentWeather.humidity,
                                      rainProbability: response.hourlyWeather[0].rain)
                
                // 현재 "시"
                let hour = Date.now.hour
                
                /// 현재 시 ~ 오늘 23시까지 hourly weather
                let weatherSummaries = response.hourlyWeather[0...23-hour].map { hourlyWeather in
                    WeatherSummary(time: hourlyWeather.dateTime.hour, statusCode: hourlyWeather.weather[0].code, temperature: hourlyWeather.temperature)
                }
                
                return (current, weatherSummaries)
            }
            .subscribe(onSuccess: { [weak self] (current, weatherSummaries) in
                self?.currentWeather.accept(current)
                self?.hourlyWeather.accept(weatherSummaries)
            }, onFailure: { error in
                print("에러 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
