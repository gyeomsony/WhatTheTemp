//
//  KakaoMapRepository.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol KakaoMapRepositoryProtocol {
    func fetchAddressSearchList(query: String) -> Single<[KakaoMapModel.Document]>
}

final class KakaoMapRepository: KakaoMapRepositoryProtocol {
    private let kakaoProvider = MoyaProvider<KakaoMapAPI>()
    
    // 검색어 입력 시 검색어가 포함된 주소 리스트 가져오기
    func fetchAddressSearchList(query: String) -> Single<[KakaoMapModel.Document]> {
        return kakaoProvider.rx.request(.getAddressList(query: query))
            .do(onSuccess: { response in
                print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "No Data")")
            })
            .map { response -> [KakaoMapModel.Document] in
                do {
                    let kakaoMapModel = try JSONDecoder().decode(KakaoMapModel.self, from: response.data)
                    return kakaoMapModel.documents.filter { $0.addressName.contains(query) }
                } catch {
                    print("Decoding error: \(error)")
                    return []
                }
            }
    }
}
