//
//  IconImageView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class IconImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFit
        self.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
