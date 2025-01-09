//
//  UIStackView+Extension.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/9/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
