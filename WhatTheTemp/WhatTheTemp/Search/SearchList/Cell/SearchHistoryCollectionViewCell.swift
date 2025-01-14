//
//  SearchHistoryCollectionViewCell.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import UIKit
import SnapKit
import RxSwift

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
    func configure(with cityWeather: CityWeather) {
        cityNameLabel.text = cityWeather.cityName
        weatherIconImageView.image = UIImage(named: WeatherAssets.getIconName(from: cityWeather.weatherCode))
        temperatureLabel.text = "\(cityWeather.roundedCurrentTemperature)°"
        weatherConditionLabel.text = cityWeather.weatherDescription
        minTemperatureLabel.text = "Min: \(cityWeather.roundedMinTemperature)°"
        maxTemperatureLabel.text = "Max: \(cityWeather.roundedMaxTemperature)°"
        baseView.backgroundColor = WeatherAssets.getColorSet(from: cityWeather.weatherCode).block
    }
    
    var disposeBag = DisposeBag() // DisposeBag를 셀 단위로 관리

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 재사용 시 DisposeBag 초기화
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
