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
    
    let addressList = BehaviorRelay<[KakaoMapModel.Document]>(value: [])
    //let addressList = PublishRelay<[KakaoMapModel.Document]>()

    init(repository: KakaoMapRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAddressList(query: String) {
        repository.fetchAddressSearchList(query: query)
            .subscribe(onSuccess: { [weak self] addressList in
                self?.addressList.accept(addressList)
            }, onFailure: { error in
                print("error \(error)")
            })
            .disposed(by: disposeBag)
    }
}
