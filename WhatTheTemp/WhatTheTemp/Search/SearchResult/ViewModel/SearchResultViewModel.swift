//
//  SearchResultViewModel.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/9/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchResultViewModel {
    private let disposeBag = DisposeBag()
    
    // 결과 데이터를 저장할 BehaviorRelay
    let resultList = BehaviorRelay<[KakaoMapModel.Document]>(value: [])
    
    // ViewModel 생성 시 데이터 바인딩
    init(addressList: Observable<[KakaoMapModel.Document]>) {
        // 검색 결과 데이터를 관찰하고 업데이트
        addressList
            .bind(to: resultList)
            .disposed(by: disposeBag)
    }
}
