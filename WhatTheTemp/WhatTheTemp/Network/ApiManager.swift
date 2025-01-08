//
//  ApiManager.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/9/25.
//

import Foundation
import Moya

final class ApiManager {
    private let provider = MoyaProvider<WeatherAPI>()
}
