//
//  MainView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/7/25.
//
import UIKit

final class MainView: UIView {
    // MARK: - UI Components
    private let locationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Cloudy"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "18'C"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mainWeatherTextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationNameLabel, weatherLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Cloudy")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var mainWeatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainWeatherTextStackView, weatherIconImageView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let feelsLikeTemperatureLabel = WeatherDegreeLabel()
    private lazy var feelsLikeStackView = VerticalStackView(with: [feelsLikeTemperatureLabel,
                                                                  WeatherTitleLabel("체감")])
    
    private let minTemperatureLabel = WeatherDegreeLabel()
    private lazy var minTemperatureStackView = VerticalStackView(with: [minTemperatureLabel,
                                                                        WeatherTitleLabel("최저")])
    
    private let maxTemperatureLabel = WeatherDegreeLabel()
    private lazy var maxTemperatureStackView = VerticalStackView(with: [maxTemperatureLabel,
                                                                        WeatherTitleLabel("최고")])
    
    private let windSpeedLabel = WeatherDegreeLabel()
    private lazy var windStackView = VerticalStackView(with: [IconImageView(image: "Wind"),
                                                              windSpeedLabel,
                                                              WeatherTitleLabel("풍속")])
    
    private let humidityLabel = WeatherDegreeLabel()
    private lazy var humidityStackView = VerticalStackView(with: [IconImageView(image: "Hymidity"),
                                                                  humidityLabel,
                                                                 WeatherTitleLabel("습도")])
    
    private let rainLabel = WeatherDegreeLabel()
    private lazy var rainStackView = VerticalStackView(with: [IconImageView(image: "Rain"),
                                                              rainLabel,
                                                              WeatherTitleLabel("강수")])
    
    // MARK: - Make UIComponet Methods
    private func makeGrayBackgroundView(with stackView: UIStackView) -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        view.addSubview(stackView)
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
