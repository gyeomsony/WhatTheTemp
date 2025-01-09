//
//  WeatherTitleLabel.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherTitleLabel: UILabel {
    init(_ title: String) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 14, weight: .light)
        textColor = .white
        textAlignment = .center
        text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
