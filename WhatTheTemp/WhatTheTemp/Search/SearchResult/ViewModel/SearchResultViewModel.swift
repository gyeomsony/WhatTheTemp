//
//  SearchResultViewModel.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchResultViewModel {
    private let disposeBag = DisposeBag()
    private let coreDataManager = SearchCoreDataManager.shared
    
    // 검색어를 저장할 BehaviorSubject
    let searchText = BehaviorSubject<String>(value: "")

    // 결과 데이터를 저장할 BehaviorRelay
    private let _resultList = BehaviorRelay<[KakaoMapModel.Document]>(value: [])

    // 외부에서 접근할 Observable 프로퍼티
    var resultList: Observable<[(document: KakaoMapModel.Document, searchText: String)]> {
        return Observable.combineLatest(_resultList.asObservable(), searchText) { documents, searchText in
            documents.map { document in
                (document: document, searchText: searchText)
            }
        }
    }
    
    // ViewModel 생성 시 데이터 바인딩
    init(addressList: Observable<[KakaoMapModel.Document]>, searchQuery: Observable<String>) {
        // 검색 결과 데이터를 관찰하고 업데이트
        addressList
            .bind(to: _resultList)
            .disposed(by: disposeBag)
        
        // 검색어를 관찰하고 업데이트
        searchQuery
            .bind(to: searchText)
            .disposed(by: disposeBag)
    }
    
    // CoreData에 히스토리 저장
    func saveSearchHistory(document: KakaoMapModel.Document) {
        guard let lat = document.latAsDouble,
              let lon = document.lonAsDouble,
              let cityName = document.cityName else {
            print("유효하지 않은 데이터")
            return
        }
        
        let addressName = document.addressName // 검색시 동까지 노출
        coreDataManager.createSearchHistoryData(lat: lat, lon: lon, cityName: cityName, addressName: addressName)
    }
}
