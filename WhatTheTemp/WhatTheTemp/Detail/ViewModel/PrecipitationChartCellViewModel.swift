//
//  PrecipitationChartCellViewModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import Foundation

import RxSwift
import RxCocoa

final class PrecipitationChartCellViewModel {
    let precipitationEntries: Driver<[ChartEntry]>
    
    init(precipitationInfo: PrecipitationInfo) {
        self.precipitationEntries = Observable.just(precipitationInfo)
            .map { model in
                zip(model.times, model.precipitation)
                    .map { time, preci in
                        ChartEntry(x: time, y: preci ?? 0.0)
                    }
            }.asDriver(onErrorJustReturn: [])
    }
}
