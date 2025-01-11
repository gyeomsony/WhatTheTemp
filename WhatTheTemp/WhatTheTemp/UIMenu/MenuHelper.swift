//
//  MenuHelper.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/11/25.
//

import UIKit

struct MenuHelper {
    static func createSettingsMenu() -> UIMenu {
        // 섭씨
        let celsiusAction = UIAction(title: "섭씨", image: UIImage(systemName: "degreesign.celsius")) { _ in
            print("섭씨 버튼 눌림")
        }
        // 화씨
        let fahrenheitAction = UIAction(title: "화씨", image: UIImage(systemName: "degreesign.fahrenheit")) { _ in
            print("화씨 버튼 눌림")
        }
        return UIMenu(title: "온도 설정", children: [celsiusAction, fahrenheitAction])
    }
    
}
