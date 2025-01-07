//
//  IconImageView.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class IconImageView: UIImageView {
    init(image: String) {
        super.init(frame: .zero)
        self.image = UIImage(named: "Wind")
        self.contentMode = .scaleAspectFit
        self.frame.size = CGSize(width: 30, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}