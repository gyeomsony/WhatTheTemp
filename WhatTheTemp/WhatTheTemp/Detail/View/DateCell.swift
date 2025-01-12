//
//  DateCell.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import UIKit

import SnapKit

final class DateCell: UICollectionViewCell {
    static let identifier = "DateCell"
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        label.layer.cornerRadius = 44.0 / 2
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dateInfo: DateInfo) {
        weekdayLabel.text = dateInfo.weekday
        dateLabel.text = dateInfo.date
    }
    
    private func configureUI() {
        contentView.addSubViews([weekdayLabel, dateLabel])
    }
    
    private func setupConstraints() {
        weekdayLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(20.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(weekdayLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44.0)
        }
    }
}
