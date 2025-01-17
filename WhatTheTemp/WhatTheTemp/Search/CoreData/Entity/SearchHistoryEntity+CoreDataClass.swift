//
//  SearchHistoryEntity+CoreDataClass.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/13/25.
//
//

import Foundation
import CoreData

@objc(SearchHistoryEntity)
public class SearchHistoryEntity: NSManagedObject {
    public static let className = "SearchHistoryEntity"
    public enum Key {
        static let lon = "lon"
        static let lat = "lat"
        static let cityName = "cityName"
        static let addressName = "addressName"
    }
}
