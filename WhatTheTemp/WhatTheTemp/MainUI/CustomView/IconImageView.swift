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
        self.image = UIImage(named: "Cloudy")   // 테스트용. 실제로는 파라미터로 받은 image 스트링 넣기.
        self.contentMode = .scaleAspectFit
        self.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
