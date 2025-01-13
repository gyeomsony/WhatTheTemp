//
//  WeatherAPI.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/8/25.
//

import Foundation
import Moya

enum WeatherAPI {
    // OpenWeather API
    case oneCall(lat: Double,      // 위도
                 lon: Double)    // 경도
    
    // Visual Crossing API
    case visualCrossing(location: String, startDate: String, endDate: String)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .oneCall:
            return URL(string: "https://api.openweathermap.org/data/3.0")!
        case .visualCrossing:
            return URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline")!
        }
    }
    
    var path: String {
        switch self {
        case .oneCall:
            return "/onecall"
        case .visualCrossing(let location, _, _):
            return "/\(location)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case let .oneCall(lat, lon):
            let parameters: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "exclude": "minutely,alerts",
                "units": "metric",
                "lang": "kr",
                "appid": APIKey.openWeatherMap
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case let .visualCrossing(_, startDate, endDate):
            let parameters: [String: Any] = [
                "startDate": startDate,
                "endDate": endDate,
                "unitGroup": "metric",
                "include": "hours",
                "key": APIKey.visualCrossing
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

