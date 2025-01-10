//
//  WeatherAPI.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/8/25.
//

import Foundation
import Moya

enum WeatherAPI {
    case oneCall(lat: Double,      // 위도
                 lon: Double)    // 경도
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/3.0")!
    }
    
    var path: String {
        switch self {
        case .oneCall:
            return "/onecall"
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
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
