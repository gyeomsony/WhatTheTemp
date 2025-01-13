//
//  WeatherSummary.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/10/25.
//

import Foundation

/// WeatherView - today, tomorrow, next 3 days에 바인딩할 모델
struct WeatherSummary {
    let time: Date                      // 시간
    let statusCode: Int                 // 날씨 코드
    let temperature: Double             // 기온
}
