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
    
    let leftVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.text = "-13°"
        return label
    }()
    
    let temparatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.text = "최저 -15°"
        return label
    }()
    
    var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.text = "최고 -5°"
        return label
    }()
    
    let rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    let weatherIconImageView = IconImageView()
    
    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.text = "남양주"
        label.textAlignment = .center
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
}

extension SearchHistoryCollectionViewCell {
    func setupUI() {
        self.backgroundColor = .clear
        baseView.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0)
        baseView.layer.cornerRadius = 20
        baseView.clipsToBounds = true
        
        addSubview(baseView)
        baseView.addSubViews([leftVerticalStackView, rightVerticalStackView])
        
        leftVerticalStackView.addArrangedSubViews([temperatureLabel, temparatureStackView])
        temparatureStackView.addArrangedSubViews([minTemperatureLabel, maxTemperatureLabel])
        
        rightVerticalStackView.addArrangedSubViews([weatherIconImageView, cityNameLabel])
    }
    
    func setupConstraint() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftVerticalStackView.snp.makeConstraints {
            $0.leading.equalTo(baseView.snp.leading).offset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        rightVerticalStackView.snp.makeConstraints {
            $0.trailing.equalTo(baseView.snp.trailing).offset(-20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
}
