//
//  SearchHistoryEntity+CoreDataProperties.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/13/25.
//
//

import Foundation
import CoreData


extension SearchHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistoryEntity> {
        return NSFetchRequest<SearchHistoryEntity>(entityName: "SearchHistoryEntity")
    }

    @NSManaged public var lon: Double
    @NSManaged public var lat: Double
    @NSManaged public var cityName: String?

}

extension SearchHistoryEntity : Identifiable {

}
