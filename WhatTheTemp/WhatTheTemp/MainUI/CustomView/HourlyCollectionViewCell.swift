//
//  HourlyCollectionViewCell.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit
import SnapKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIconImageView = IconImageView(image: "Cloudy")
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hourLabel,
                                                       weatherIconImageView,
                                                       temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
