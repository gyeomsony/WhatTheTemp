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
    
    private let coreDataManager = SearchCoreDataManager.shared
    
    let cityWeathers = PublishRelay<[CityWeather]>()
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
        
        let entites = coreDataManager.readSearchHistoryData()
        fetchMultipleWeathers(entites: entites)
    }
    
    private func fetchMultipleWeathers(entites: [SearchHistoryEntity]) {
        repository.fetchWeathers(entites: entites)
            .map { responses -> [CityWeather] in
                responses.enumerated().map { (index, response) in
                    let cityWeather = CityWeather(weatherCode: response.currentWeather.weather[0].code,
                                                  cityName: entites[index].cityName ?? "",
                                                  currentTemperature: response.currentWeather.temperature,
                                                  minTemperature: response.dailyWeather[0].temperature.minTemperature,
                                                  maxTemperature: response.dailyWeather[0].temperature.maxTemperature)
                    return cityWeather
                }
            }
            .subscribe(onSuccess: { [weak self] cityWeathers in
                        // Emit the weather data through the relay
                        self?.cityWeathers.accept(cityWeathers)
                    }, onFailure: { error in
                        print("Error fetching weathers: \(error)")
                    })
                    .disposed(by: disposeBag)
    }
}
