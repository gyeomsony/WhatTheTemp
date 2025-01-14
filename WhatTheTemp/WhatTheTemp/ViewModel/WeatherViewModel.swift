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
    private let locationRepository: LocationRepositoryProtocol
    private let weatherRepository: WeatherRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    let currentWeather = PublishRelay<Current>()
    let todayHourly = PublishRelay<[WeatherSummary]>()
    let tomorrowHourly = PublishRelay<[WeatherSummary]>()
    let nextFiveDaily = PublishRelay<[WeatherSummary]>()
    
    init(locationRepository: LocationRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.locationRepository = locationRepository
        self.weatherRepository = weatherRepository
        requestWeatherAPI()
    }
    
    /// LocationRepository에서 사용자 위치 정보 수집 권한이 업데이트 되면 이벤트를 받아 네트워크 통신 요청
    func requestWeatherAPI() {
        locationRepository.authorizationUpdated
            .subscribe { [weak self] _ in
                guard
                    let self = self,
                    let coordinate = locationRepository.currentLocation?.coordinate
                else { return }
                
                fetchWeatherResponse(lat: coordinate.latitude, lon: coordinate.longitude)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchWeatherResponse(lat: Double, lon: Double) {
        weatherRepository.fetchWeather(lat: lat, lon: lon)
            .map { response -> (Current, [WeatherSummary], [WeatherSummary], [WeatherSummary]) in
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
                let todayHourly = response.hourlyWeather[0...23-hour].map { hourlyWeather in
                    WeatherSummary(time: hourlyWeather.dateTime.hour, statusCode: hourlyWeather.weather[0].code, temperature: hourlyWeather.temperature)
                }
                
                /// 내일 0시 ~ 23시까지 hourly weather
                let tomorrowHourly = response.hourlyWeather[24-hour...47-hour].map { hourlyWeather in
                    WeatherSummary(time: hourlyWeather.dateTime.hour, statusCode: hourlyWeather.weather[0].code, temperature: hourlyWeather.temperature)
                }
                
                /// 오늘로부터 이틀 뒤 ~ 6일 뒤 (5일 간) daily weather
                let nextFiveDaily = response.dailyWeather[2...6].map { dailyWeather in
                    WeatherSummary(time: dailyWeather.dateTime.day, statusCode: dailyWeather.weather[0].code, temperature: dailyWeather.temperature.temperature)
                }
                
                return (current, todayHourly, tomorrowHourly, nextFiveDaily)
            }
            .subscribe(onSuccess: { [weak self] (current, todayHourly, tomorrowHourly, nextFiveDaily) in
                self?.currentWeather.accept(current)
                self?.todayHourly.accept(todayHourly)
                self?.tomorrowHourly.accept(tomorrowHourly)
                self?.nextFiveDaily.accept(nextFiveDaily)
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
