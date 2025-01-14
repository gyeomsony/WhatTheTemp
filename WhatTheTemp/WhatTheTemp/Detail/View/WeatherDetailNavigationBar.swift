//
//  WeatherDetailNavigationBar.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import UIKit

import SnapKit

final class WeatherDetailNavigationBar: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "기상 상태"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        
        return label
    }()
    
    private(set) var dismissButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.tintColor = UIColor(red: 148/255, green: 147/255, blue: 155/255, alpha: 1.0)
        button.layer.cornerRadius = 40.0 / 2
        button.backgroundColor = UIColor(red: 49/255, green: 48/255, blue: 53/255, alpha: 1.0)
        button.clipsToBounds = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
        
        backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabel, dismissButton].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        dismissButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(40.0)
        }
    }
}
