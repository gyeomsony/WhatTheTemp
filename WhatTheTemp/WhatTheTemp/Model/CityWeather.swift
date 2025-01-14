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
    
    // 반올림 및 반내림을 적용한 계산 속성
    var roundedCurrentTemperature: Int {
        return Int(currentTemperature.roundedToNearestHalf)
    }
    
    var roundedMinTemperature: Int {
        return Int(minTemperature.roundedToNearestHalf)
    }
    
    var roundedMaxTemperature: Int {
        return Int(maxTemperature.roundedToNearestHalf)
    }
}

extension Double {
    // 0.5 이상은 반올림, 0.4 이하는 반내림
    var roundedToNearestHalf: Double {
        return (self * 2).rounded() / 2
    }
}
