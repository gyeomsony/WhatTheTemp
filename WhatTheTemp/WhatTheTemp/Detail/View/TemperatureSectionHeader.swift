//
//  TemperatureSectionHeader.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/13/25.
//

import UIKit

import SnapKit

final class TemperatureSectionHeader: UICollectionReusableView {
    private let MaxTemperatureLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let MinTemperatureLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
