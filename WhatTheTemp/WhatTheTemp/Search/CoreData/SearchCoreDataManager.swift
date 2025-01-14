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
        // 중복 체크를 위한 FetchRequest 생성
        let fetchRequest: NSFetchRequest<SearchHistoryEntity> = SearchHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
        
        do {
            let existingRecords = try self.context.fetch(fetchRequest)
            
            // cityName이 이미 존재하면 중복 저장하지 않음
            if !existingRecords.isEmpty {
                print("이미 저장된 cityName: \(cityName)")
                return
            }
            
            // 중복되지 않으면 새로운 데이터 생성
            guard let entity = NSEntityDescription.entity(forEntityName: SearchHistoryEntity.className, in: context) else {
                print("Entity not found")
                return
            }
            
            let newHistory = NSManagedObject(entity: entity, insertInto: context)
            newHistory.setValue(lon, forKey: SearchHistoryEntity.Key.lon)
            newHistory.setValue(lat, forKey: SearchHistoryEntity.Key.lat)
            newHistory.setValue(cityName, forKey: SearchHistoryEntity.Key.cityName)
            newHistory.setValue(addressName, forKey: SearchHistoryEntity.Key.addressName)
            
            try self.context.save()
            print("히스토리 데이터 저장 성공")
        } catch {
            print("히스토리 데이터 저장 실패 또는 중복 체크 중 에러: \(error.localizedDescription)")
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
//    func deleteSearchHistoryData(lat: Double, lon: Double) {
//        let fetchRequest = SearchHistoryEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lon == %lf", lat, lon)
//        
//        do {
//            let results = try self.context.fetch(fetchRequest)
//            
//            for object in results {
//                self.context.delete(object)
//            }
//            
//            try self.context.save()
//            print("히스토리 데이터 삭제 성공")
//        } catch {
//            print("히스토리 데이터 삭제 실패: \(error.localizedDescription)")
//        }
//    }
    func deleteSearchHistoryData(cityName: String, completion: @escaping (Bool) -> Void) {
        let fetchRequest = SearchHistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            
            for object in results {
                self.context.delete(object)
            }
            
            try self.context.save()
            print("히스토리 데이터 삭제 성공")
            completion(true)
        } catch {
            print("히스토리 데이터 삭제 실패: \(error.localizedDescription)")
            completion(false)
        }
    }
}
