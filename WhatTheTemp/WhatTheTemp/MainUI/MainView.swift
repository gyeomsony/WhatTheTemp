//
//  MainView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/7/25.
//
import UIKit

final class MainView: UIView {
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
}
