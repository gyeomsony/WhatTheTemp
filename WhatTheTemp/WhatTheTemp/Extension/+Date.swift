//
//  +Date.swift
//  WhatTheTemp
//
//  Created by EMILY on 13/01/2025.
//

import Foundation

extension Date {
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    // 현재 시간이 day인지 night인지 구분하여 day면 true, night이면 false 반환
    // 오전 6시 ~ 오후 5시 : day
    // 오후 5시 1분 ~ 오전 5시 59분 : night
    var isDayTime: Bool {
        //let hour = Calendar.current.component(.hour, from: self)
        
        if self.hour >= 6 && self.hour <= 17 {
            return true
        } else {
            return false
        }
    }
}
