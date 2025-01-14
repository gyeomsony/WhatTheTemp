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
    
    let coreDataManager = SearchCoreDataManager.shared
    
    // BehaviorRelay로 변경하여 값을 저장하고 접근 가능하게 함
    let cityWeathers = BehaviorRelay<[CityWeather]>(value: [])
    
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
    
    func deleteCityWeather(at index: Int) {
        guard index >= 0, index < cityWeathers.value.count else { return }
        
        let cityWeather = cityWeathers.value[index]
        
        // Core Data에서 cityName을 기준으로 삭제
        coreDataManager.deleteSearchHistoryData(cityName: cityWeather.cityName) { [weak self] success in
            if success {
                var updatedCityWeathers = self?.cityWeathers.value ?? []
                updatedCityWeathers.remove(at: index)  // 데이터에서 삭제
                self?.cityWeathers.accept(updatedCityWeathers)  // 변경된 데이터로 업데이트
            } else {
                print("Failed to delete city weather.")
            }
        }
    }
}
