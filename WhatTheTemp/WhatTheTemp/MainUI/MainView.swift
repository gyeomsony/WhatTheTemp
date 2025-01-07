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
    
    // MARK: - Make UIComponet Methods
    private func makeGrayBackgroundView(with stackView: UIStackView) -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        view.addSubview(stackView)
        return view
    }
    
    private func makeWeatherDegreeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    private func makeWeatherTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    private func makeWeatherIconImageView(_ image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 30, height: 30)
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
