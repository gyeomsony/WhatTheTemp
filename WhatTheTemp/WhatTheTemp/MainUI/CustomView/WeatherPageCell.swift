//
//  WeatherPageCell.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherPageCell: UICollectionViewCell {
    private let weatherView = WeatherView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWeatherView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWeatherView() {
        contentView.addSubview(weatherView)
        weatherView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}
