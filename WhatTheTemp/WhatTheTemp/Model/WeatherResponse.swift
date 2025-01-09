//
//  WeatherResponse.swift
//  WhatTheTemp
//
//  Created by EMILY on 09/01/2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let currentWeather: CurrentWeather
    let hourlyWeather: [HourlyWeather]
    let dailyWeather: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case currentWeather = "current"
        case hourlyWeather = "hourly"
        case dailyWeather = "daily"
    }
}

struct Weather: Decodable {
    let code: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case code = "id"
        case description
    }
}

struct CurrentWeather: Decodable {
    let temperature: Double                 // 현재 온도
    let feelsLike: Double                   // 체감 온도
    let humidity: Int                       // 현재 습도
    let windSpeed: Double                   // 현재 풍속
    let weather: Weather                    // 날씨 코드, 날씨 상태
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity
        case feelsLike = "feels_like"
        case windSpeed = "wind_speed"
        case weather
    }
}

struct HourlyWeather: Decodable {
    let dt: Int                              // timeIntervalSince1970 값
    let temperature: Double                 // 시간 별 온도
    let rain: Int                            // 강수 확률 MARK: current weather에 강수 확률이 없어서 이 값을 현재 강수 확률로 활용해야 할 듯
    let weather: Weather                    // 시간 별 날씨 icon에 활용할 날씨 코드
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temperature = "temp"
        case rain = "pop"
        case weather
    }
}

struct DailyWeather: Decodable {
    let dt: Int
    let temperature: DailyTemperature
    let weather: Weather
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temperature = "temp"
        case weather
    }
}

struct DailyTemperature: Decodable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "day"
    }
}
