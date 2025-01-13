//
//  SearchCoreDataManager.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/13/25.
//

import CoreData
import UIKit

final class SearchCoreDataManager {
    static let shared = SearchCoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate 접근 실패")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    // Create
    func createSearchHistoryData(lat: Double, lon: Double, cityName: String, addressName: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: SearchHistoryEntity.className, in: context) else {
            print("Entity not found")
            return
        }
        
        let newHistory = NSManagedObject(entity: entity, insertInto: context)
        
        newHistory.setValue(lon, forKey: SearchHistoryEntity.Key.lon)
        newHistory.setValue(lat, forKey: SearchHistoryEntity.Key.lat)
        newHistory.setValue(cityName, forKey: SearchHistoryEntity.Key.cityName)
        newHistory.setValue(addressName, forKey: SearchHistoryEntity.Key.addressName)
        
        do {
            try self.context.save()
            print("히스토리 데이터 저장 성공")
        } catch {
            print("히스토리 데이터 저장 실패: \(error.localizedDescription)")
        }
    }
    
    // Read
    func readSearchHistoryData() -> [SearchHistoryEntity] {
        let fetchRequest: NSFetchRequest<SearchHistoryEntity> = SearchHistoryEntity.fetchRequest()
        
        do {
            return try self.context.fetch(fetchRequest)
        } catch {
            print("히스토리 데이터 읽기 실패: \(error.localizedDescription)")
            return []
        }
    }
    
    // Update
    func updateSearchHistoryData(contact: SearchHistoryEntity, lat: Double, lon: Double, cityName: String, addressName: String) {
        contact.setValue(lat, forKey: SearchHistoryEntity.Key.lat)
        contact.setValue(lon, forKey: SearchHistoryEntity.Key.lon)
        contact.setValue(cityName, forKey: SearchHistoryEntity.Key.cityName)
        contact.setValue(addressName, forKey: SearchHistoryEntity.Key.addressName)
        
        do {
            try self.context.save()
            print("히스토리 데이터 업데이트 성공")
        } catch {
            print("히스토리 데이터 업데이트 실패: \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deleteSearchHistoryData(lat: Double, lon: Double) {
        let fetchRequest = SearchHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lon == %lf", lat, lon)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            
            for object in results {
                self.context.delete(object)
            }
            
            try self.context.save()
            print("히스토리 데이터 삭제 성공")
        } catch {
            print("히스토리 데이터 삭제 실패: \(error.localizedDescription)")
        }
    }
}
