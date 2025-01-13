//
//  SearchHistoryCollectionViewCell.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/9/25.
//

import UIKit
import SnapKit

final class SearchHistoryCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    let baseView = UIView()
    
    let weatherIconImageView = IconImageView(name: "clearDay")
    
    let leftVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var weatherConditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let temparatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CoreData에서 읽어온 데이터를 셀에 설정
    func configure(with history: SearchHistoryEntity) {
        cityNameLabel.text = history.cityName
        // 날씨 관련 데이터를 셀에 표시
    }
    
    func updateWeatherInfo(current: Current) {
        weatherIconImageView.image = UIImage(named: WeatherAssets.getIconName(from: current.weatherCode))
        temperatureLabel.text = "\(current.currentTemperature)°"
        weatherConditionLabel.text = current.weatherDescription
        minTemperatureLabel.text = "Min: \(current.minTemperature)°"
        maxTemperatureLabel.text = "Max: \(current.maxTemperature)°"
    }
}

extension SearchHistoryCollectionViewCell {
    func setupUI() {
        self.backgroundColor = .clear
        baseView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
        baseView.layer.cornerRadius = 20
        baseView.clipsToBounds = true
        
        addSubview(baseView)
        baseView.addSubViews([weatherIconImageView, leftVerticalStackView, rightVerticalStackView])
        
        leftVerticalStackView.addArrangedSubViews([cityNameLabel, weatherConditionLabel])
        temparatureStackView.addArrangedSubViews([minTemperatureLabel, maxTemperatureLabel])
        
        rightVerticalStackView.addArrangedSubViews([temperatureLabel, temparatureStackView])
    }
    
    func setupConstraint() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        weatherIconImageView.snp.makeConstraints {
            $0.leading.equalTo(baseView.snp.leading).offset(20)
            $0.top.equalToSuperview().inset(10)
        }
        
        leftVerticalStackView.snp.makeConstraints {
            $0.leading.equalTo(baseView.snp.leading).offset(20)
            $0.bottom.equalTo(rightVerticalStackView.snp.bottom)
        }
        
        rightVerticalStackView.snp.makeConstraints {
            $0.trailing.equalTo(baseView.snp.trailing).offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
