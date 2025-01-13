//
//  +Double.swift
//  WhatTheTemp
//
//  Created by EMILY on 13/01/2025.
//

import Foundation

extension Double {
    /// timeIntervalSince1970 값에서 현재 "시각" 추출하여 반환해주는 계산 프로퍼티
    var hour: Int {
        let date = Date(timeIntervalSince1970: self)
        return date.hour
    }
}
