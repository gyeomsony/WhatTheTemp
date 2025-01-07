//
//  VerticalStackView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class VerticalStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(with views: [UIView]) {
        self.init(arrangedSubviews: views)
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 5
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
