//
//  APIKey.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/9/25.
//

import Foundation

struct APIKey {
    static let openWeatherMap: String = {
        guard let key = Bundle.main.infoDictionary?["OpenWeatherMapAPIKey"] as? String else {
            print("API Key를 읽어오지 못했습니다. Info.plist를 확인하세요.")
            fatalError("APIKey가 설정되지 않았습니다.")
        }
        print("API Key가 로드되었습니다.")
        return key
    }()
}
