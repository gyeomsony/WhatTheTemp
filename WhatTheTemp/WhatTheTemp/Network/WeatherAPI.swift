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
                 lon: Double,      // 경도
                 exclude: String,  // 제외할 항목
                 units: String)    // 단위 (metric = 온도 섭씨 (°C))
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
        case let .oneCall(lat, lon, exclude, units):
            let parameters: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "exclude": exclude,
                "units": units,
                "appid": APIKey.openWeatherMap
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
