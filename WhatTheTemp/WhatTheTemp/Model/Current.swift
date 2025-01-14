//
//  Current.swift
//  WhatTheTemp
//
//  Created by EMILY on 1/10/25.
//

import Foundation

/// WeatherView - 현재 날씨에 바인딩할 모델
struct Current {
    let locationName: String
    let weatherDescription: String      // 구름 조금
    let currentTemperature: Double      // 현재 기온
    let weatherCode: Int                // 날씨 코드 >> 날씨 아이콘
    
    let feelsLikeTemperature: Double    // 체감 온도
    let minTemperature: Double          // 최저 기온
    let maxTemperature: Double          // 최고 기온
    
    let windSpeed: Double               // 현재 풍속
    let humidity: Double                // 현재 습도
    let rainProbability: Double         // 현재 강수 확률
}

extension Current {
    func toCityWeather(cityName: String) -> CityWeather {
        return CityWeather(
            weatherCode: self.weatherCode,
            cityName: cityName,
            weatherDescription: self.weatherDescription,
            currentTemperature: self.currentTemperature,
            minTemperature: self.minTemperature,
            maxTemperature: self.maxTemperature
        )
    }
}
