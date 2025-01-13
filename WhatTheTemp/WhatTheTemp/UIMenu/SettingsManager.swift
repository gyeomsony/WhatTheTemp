//
//  SettingsManager.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/11/25.
//

import UIKit

// 온도 단위를 나타내는 열거형
enum TempUnit: String {
    case celsius = "섭씨"
    case fahrenheit = "화씨"
}

// 유저의 온도 선택값 저장하고 불러오기
struct SettingsManager {
    private static let tempUnitKey = "TemperatureUnit"
    
    // 선택한 온도 단위를 UserDefaults에 저장
    static func saveTempUnit(_ unit: TempUnit) {
        UserDefaults.standard.set(unit.rawValue, forKey: tempUnitKey)
    }
    
    // UserDefaults에서 저장된 온도 단위를 불러오기
    static func getTempUnit() -> TempUnit {
        let value = UserDefaults.standard.string(forKey: tempUnitKey) ?? TempUnit.celsius.rawValue
        return TempUnit(rawValue: value) ?? .celsius
    }
    
    // 온도 변환 함수
    static func convertTemperature(value: Double, to unit: TempUnit) -> Double {
        switch unit {
        case .celsius:
            return (value - 32) * 5.0 / 9.0
        case .fahrenheit:
            return (value * 9.0 / 5.0) + 32
        }
    }
}
