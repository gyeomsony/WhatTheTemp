//
//  TemperatureCharCellViewModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import RxSwift
import RxCocoa

struct ChartEntry {
    let x: Double
    let y: Double
}

final class TemperatureCharCellViewModel {
    let temperatureEntries: Driver<[ChartEntry]>
    let precipitationEntries: Driver<[ChartEntry]>
    let weatherIcons: Driver<[String]>
    
    init(temperatureInfo: TemperatureInfo) {
        self.temperatureEntries = Observable.just(temperatureInfo)
            .map { model in
                zip(model.times, model.temperature)
                    .map { time, temp in
                        ChartEntry(x: time, y: temp)
                    }
            }.asDriver(onErrorJustReturn: [])
        
        self.precipitationEntries = Observable.just(temperatureInfo)
            .map { model in
                zip(model.times, model.precipitation)
                    .map { time, preci in
                        ChartEntry(x: time, y: preci ?? 0.0)
                    }
            }.asDriver(onErrorJustReturn: [])
            
        
        self.weatherIcons = Observable.just(temperatureInfo.conditions)
            .map { model -> [String] in
                model.enumerated().map { index, condition in
                    let isDayTime = (3...8).contains(index)
                    
                    return VXCWeatherIcons.getIconName(from: condition, isDayTime: isDayTime)
                }
            }.asDriver(onErrorJustReturn: [])
    }
}
