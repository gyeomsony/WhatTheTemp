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
            .map { response -> Current in
                let current = Current(weatherDescription: response.currentWeather.weather[0].description,
                                      currentTemperature: response.currentWeather.temperature,
                                      weatherCode: response.currentWeather.weather[0].code,
                                      feelsLikeTemperature: response.currentWeather.feelsLike,
                                      minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                      maxTemperature: response.dailyWeather[0].temperature.maxTemperature,
                                      windSpeed: response.currentWeather.windSpeed,
                                      humidity: response.currentWeather.humidity,
                                      rainProbability: response.hourlyWeather[0].rain)
                return current
            }
            .subscribe(onSuccess: { [weak self] current in
                self?.currentWeather.accept(current)
            }, onFailure: { error in
                print("에러 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - SearchViewController 바인딩용으로 기존 코드 건드리지 않기 위함
extension WeatherViewModel {
    func fetchWeatherResponseAsObservable(lat: Double, lon: Double) -> Observable<Current> {
        return repository.fetchWeather(lat: lat, lon: lon)
            .map { response -> Current in
                let current = Current(weatherDescription: response.currentWeather.weather[0].description,
                                      currentTemperature: response.currentWeather.temperature,
                                      weatherCode: response.currentWeather.weather[0].code,
                                      feelsLikeTemperature: response.currentWeather.feelsLike,
                                      minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                      maxTemperature: response.dailyWeather[0].temperature.maxTemperature,
                                      windSpeed: response.currentWeather.windSpeed,
                                      humidity: response.currentWeather.humidity,
                                      rainProbability: response.hourlyWeather[0].rain)
                return current
            }
            .asObservable() // Single을 Observable로 변환
    }
}
