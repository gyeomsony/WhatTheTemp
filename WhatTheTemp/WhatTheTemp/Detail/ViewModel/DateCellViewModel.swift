//
//  DateCellViewModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DateCellViewModel {
    let dateInfo: DateInfo
    
    let weekdayText: Observable<String>
    let dateText: Observable<String>
    let isSelected: Observable<Bool>
    
    init(dateInfo: DateInfo, isSelected: Observable<Bool>) {
        self.dateInfo = dateInfo
        self.weekdayText = Observable.just(dateInfo.weekday)
        self.dateText = Observable.just(dateInfo.date)
        self.isSelected = isSelected
    }
}
