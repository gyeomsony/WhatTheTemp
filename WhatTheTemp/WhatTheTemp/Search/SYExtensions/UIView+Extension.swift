//
//  UIView+Extension.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/9/25.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
