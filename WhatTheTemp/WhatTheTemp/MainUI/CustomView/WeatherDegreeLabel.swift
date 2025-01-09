//
//  WeatherDegreeLabel.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherDegreeLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 16, weight: .bold)
        textColor = .white
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
