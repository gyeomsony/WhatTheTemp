//
//  WeatherAssets.swift
//  WhatTheTemp
//
//  Created by EMILY on 09/01/2025.
//

import Foundation

enum WeatherAssets: String {
    case clearDay
    case clearNight
    case cloudDay
    case cloudNight
    case drizzleDay
    case drizzleNight
    case dustDay
    case dustNight
    case heavyRainDay
    case heavyRainNight
    case lightRainDay
    case lightRainNight
    case lightSnowDay
    case lightSnowNight
    case mistDay
    case mistNight
    case rainDay
    case rainNight
    case snowDay
    case snowNight
    case squalls
    case thunderDay
    case thunderNight
    case thunderRainDay
    case thunderRainNight
    
    static func getIconName(from code: Int, isDayTime: Bool) -> String {
        switch code {
        case 200...202, 230...232:
            return isDayTime ? thunderRainDay.rawValue : thunderRainNight.rawValue
        case 210...221:
            return isDayTime ? thunderDay.rawValue : thunderNight.rawValue
        case 300..<400, 520...531:
            return isDayTime ? drizzleDay.rawValue : drizzleNight.rawValue
        case 500:
            return isDayTime ? lightRainDay.rawValue : lightRainNight.rawValue
        case 501:
            return isDayTime ? rainDay.rawValue : rainNight.rawValue
        case 502...504:
            return isDayTime ? heavyRainDay.rawValue : heavyRainNight.rawValue
        case 511, 600, 611...622:
            return isDayTime ? lightSnowDay.rawValue : lightSnowNight.rawValue
        case 601, 602:
            return isDayTime ? snowDay.rawValue : snowNight.rawValue
        case 701, 711, 721, 741:
            return isDayTime ? mistDay.rawValue : mistNight.rawValue
        case 731, 751, 761, 762:
            return isDayTime ? dustDay.rawValue : dustNight.rawValue
        case 771, 781:
            return squalls.rawValue
        case 801...804:
            return isDayTime ? cloudDay.rawValue : cloudNight.rawValue
        default:
            return isDayTime ? clearDay.rawValue : clearNight.rawValue
        }
    }
}