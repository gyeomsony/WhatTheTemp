//
//  KakaoMapModel.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import Foundation

// API Response 모델
struct KakaoMapModel: Decodable {
    let documents: [Document]
    let meta: Meta

    struct Document: Decodable {
        let addressName: String
        let cityName: String?
        let lon: String
        let lat: String
        
        var lonAsDouble: Double? {
            return Double(lon)
        }
        
        var latAsDouble: Double? {
            return Double(lat)
        }

        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case cityName = "region_2depth_name"
            case lon = "x"
            case lat = "y"
        }
    }

    struct Meta: Decodable {
        let pageableCount: Int
        let totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case pageableCount = "pageable_count"
            case totalCount = "total_count"
        }
    }
}
