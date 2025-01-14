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
        let lon: String
        let lat: String
        
        var lonAsDouble: Double? {
            return Double(lon)
        }
        
        var latAsDouble: Double? {
            return Double(lat)
        }
        
        // address 객체를 추가하여 region_2depth_name을 포함
        struct Address: Decodable {
            let region2DepthName: String?
            
            enum CodingKeys: String, CodingKey {
                case region2DepthName = "region_2depth_name"
            }
        }
        
        let address: Address
        
        // cityName은 address.region2DepthName을 통해 가져옴
        var cityName: String? {
            return address.region2DepthName
        }
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case lon = "x"
            case lat = "y"
            case address // address 객체를 매핑
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
