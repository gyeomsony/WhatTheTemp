//
//  SectionModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import Foundation

import RxDataSources

enum SectionItem {
    case date(DateInfo)
    case temp(TemperatureInfo)
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
