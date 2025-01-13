//
//  CityWeather.swift
//  WhatTheTemp
//
//  Created by EMILY on 12/01/2025.
//

import Foundation

/// SearchHistoryView - collection view와 바인딩할 모델
struct CityWeather {
    let weatherCode: Int
    let cityName: String
    let weatherDescription: String
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
}
