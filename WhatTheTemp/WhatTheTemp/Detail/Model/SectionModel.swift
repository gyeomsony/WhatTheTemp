//
//  SectionModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import Foundation

import RxDataSources

enum SectionItem {
    case date(DateCellViewModel)
    case temp(TemperatureCharCellViewModel)
//    case preci(PrecipitationChartCellViewModel)
}

struct SectionModel {
    let header: String?
    let footer: String?
    var items: [SectionItem]
}

extension SectionModel: SectionModelType {
    typealias Item = SectionItem
    
    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
