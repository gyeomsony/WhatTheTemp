//
//  MenuHelper.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/11/25.
//

import UIKit

/// 메뉴를 생성하고 설정 버튼에 표시할 수 있는 헬퍼 구조체
enum MenuHelper {
    static func createSettingsMenu(currentTemperature: Double, updateTemperature: @escaping (Double) -> Void) -> UIMenu {
        // 섭씨 선택 항목
        let celsiusAction = UIAction(
            title: "섭씨",
            image: UIImage(systemName: "degreesign.celsius"),
            state: SettingsManager.getTempUnit() == TempUnit.celsius ? .on : .off
        ) { _ in
            print("섭씨 버튼 눌림")
            
            // 유저 디폴츠에 섭씨 저장
            SettingsManager.saveTempUnit(.celsius)
            NotificationCenter.default.post(name: .tempUnitChanged, object: nil)
            
            // 온도 변환 후 UI 업데이트
            let convertedTemperature = SettingsManager.convertTemperature(value: currentTemperature, to: .celsius)
            updateTemperature(convertedTemperature)
        }
        
        // 화씨 선택 항목
        let fahrenheitAction = UIAction(
            title: "화씨",
            image: UIImage(systemName: "degreesign.fahrenheit"),
            state: SettingsManager.getTempUnit() == TempUnit.fahrenheit ? .on : .off
        ) { _ in
            print("화씨 버튼 눌림")
            
            // 유저 디폴츠에 화씨 저장
            SettingsManager.saveTempUnit(.fahrenheit)
            NotificationCenter.default.post(name: .tempUnitChanged, object: nil)
            
            // 온도 변환 후 UI 업데이트 
            let convertedTemperature = SettingsManager.convertTemperature(value: currentTemperature, to: .fahrenheit)
            updateTemperature(convertedTemperature)
        }
        
        // 섭씨와 화씨를 포함한 메뉴 반환
        return UIMenu(
            title: "온도 설정",
            children: [celsiusAction, fahrenheitAction]
        )
    }
}

/// Notification 이름 확장
/// 온도 단위가 변경되었음을 알리는 Notification 이름
extension Notification.Name {
    static let tempUnitChanged = Notification.Name("tempUnitChanged")
}
