//
//  WeatherPageCell.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit
import RxSwift

final class WeatherPageCell: UICollectionViewCell {
    private(set) var weatherView = WeatherView()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWeatherView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        weatherView.resetData()
    }
    
    private func setupWeatherView() {
        contentView.addSubview(weatherView)
        weatherView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
