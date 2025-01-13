//
//  SearchHistoryViewModel.swift
//  WhatTheTemp
//
//  Created by EMILY on 12/01/2025.
//

import Foundation
import RxSwift
import RxCocoa

class SearchHistoryViewModel {
    private let repository: WeatherRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    let cityWeathers = PublishRelay<[CityWeather]>()
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMultipleWeathers(coordinates: [(lat: Double, lon: Double)]) {
        repository.fetchWeathers(coordinates: coordinates)
            .map { responses -> [CityWeather] in
                responses.map { response in
                    let cityWeather = CityWeather(weatherCode: response.currentWeather.weather[0].code,
                                                  cityName: "임시값 서울시",
                                                  weatherDescription: response.currentWeather.weather[0].description,
                                                  currentTemperature: response.currentWeather.temperature,
                                                  minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                                  maxTemperature: response.dailyWeather[0].temperature.maxTemperature)
                    return cityWeather
                }
            }
            .subscribe(
                onSuccess: { [weak self] cityWeathers in
                    self?.cityWeathers.accept(cityWeathers)
                },
                onFailure: { error in
                    print("에러 발생: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}
