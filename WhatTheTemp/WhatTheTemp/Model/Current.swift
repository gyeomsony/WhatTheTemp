//
//  Current.swift
//  WhatTheTemp
//
//  Created by EMILY on 1/10/25.
//

import Foundation

/// WeatherView - 현재 날씨에 바인딩할 모델
struct Current {
    let locationName: String = "서울시"
    let currentTemperature: Double      // 현재 기온
    let weatherCode: Int                // 날씨 코드 >> 날씨 아이콘
    
    let feelsLikeTemperature: Double    // 체감 온도
    let minTemperature: Double          // 최저 기온
    let maxTemperature: Double          // 최고 기온
    
    let windSpeed: Double               // 현재 풍속
    let humidity: Double                // 현재 습도
    let rainProbability: Double         // 현재 강수 확률
    
    /// 날씨 code를 통해 description 반환
    var weatherDescription: String {
        return WeatherAssets.getWeatherDescription(from: self.weatherCode)
    }
}

extension Current {
    func toCityWeather(cityName: String) -> CityWeather {
        return CityWeather(
            weatherCode: self.weatherCode,
            cityName: cityName,
            currentTemperature: self.currentTemperature,
            minTemperature: self.minTemperature,
            maxTemperature: self.maxTemperature
        )
    }
}
