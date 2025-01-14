//
//  KakapMapViewModel.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchViewModel {
    private let repository: KakaoMapRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    // 주소 리스트를 저장할 BehaviorRelay
    let addressList = BehaviorRelay<[KakaoMapModel.Document]>(value: [])
    // 검색어를 저장할 BehaviorRelay
    let searchQuery = BehaviorRelay<String>(value: "")
    
    init(repository: KakaoMapRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAddressList(query: String) {
        searchQuery.accept(query) // 검색어 업데이트
        repository.fetchAddressSearchList(query: query)
            .subscribe(onSuccess: { [weak self] addressList in
                self?.addressList.accept(addressList)
            }, onFailure: { error in
                print("error \(error)")
            })
            .disposed(by: disposeBag)
    }
    
//    func fetchAddressList(query: String) {
//        repository.fetchAddressList(query: query)
//            .subscribe(onSuccess: { [weak self] response in
//                self?.addressList.accept(response.documents)
//            }, onFailure: { error in
//                print("Error fetching address list: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
}
