//
//  KakaoMapAPI.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import Foundation
import Moya

enum KakaoMapAPI {
    case getAddressList(query: String)
}

// https://dapi.kakao.com/v2/local/search/address.json?query=서울
extension KakaoMapAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://dapi.kakao.com") else {
            fatalError("Invalid base URL: Check the URL format")
        }
        return url
    }
    
    var path: String {
        return "/v2/local/search/address.json"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getAddressList(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "KakaoAK 38d11c10ea33d820890fb070d711efbb"] // REST API 키를 입력
    }
    
    var sampleData: Data {
        return Data()
    }
}
