//  WeatherDetailViewModel.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import Foundation
import RxSwift
import RxCocoa

final class WeatherDetailViewModel {
    private let repository: WeatherRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    
    let viewDidLoadTrigger = PublishRelay<Void>()
    let weatherSections = BehaviorRelay<[SectionModel]>(value: [])
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
        
        viewDidLoadTrigger
            .flatMap { [weak self] _ -> Observable<[SectionModel]> in
                guard let self = self else { return .empty() }
                return self.repository.fetchVXCWeatherData(
                    location: "37.4837,127.0325",
                    startDate: "2025-01-10",
                    endDate: "2025-01-12"
                ).asObservable()
                .map { response in
                    let dateSection = self.createDateSection(from: response)
                    let weatherSection = self.createWeatherSection(from: response)
                    return [dateSection, weatherSection]
                }
            }.bind(to: weatherSections)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Helper Methods
    
    private func createDateSection(from response: VXCWeatherResponse) -> SectionModel {
        let dateItems = response.days.compactMap { self.convertToDateInfo(from: $0) }
            .map { SectionItem.date($0) }
        let footer = parseFullDate(todayDateString())
        
        return SectionModel(
            header: nil,
            footer: footer,
            items: dateItems
        )
    }
    
    // 날씨 정보를 기반으로 SectionModel 생성
    private func createWeatherSection(from response: VXCWeatherResponse) -> SectionModel {
        let temperatureItems = response.days.map { day in
            let times = day.hours.compactMap { self.parseTimeToDouble($0.datetime) }
            let temperatures = day.hours.map { $0.temp }
            // 홀수 번째 조건만 선택하여 최대 12개를 가져옴
            let conditions = day.hours.enumerated()
                .filter { index, _ in index % 2 != 0 }
                .prefix(12)
                .map { $0.element.conditions }
            
            return SectionItem.temp(
                TemperatureInfo(
                    date: day.datetime,
                    times: times,
                    temperature: temperatures,
                    conditions: conditions
                )
            )
        }
        
        return SectionModel(
            header: nil,
            footer: nil,
            items: temperatureItems
        )
    }
    
    // VXCDailyWeather 데이터를 DateInfo로 변환
    private func convertToDateInfo(from dailyWeather: VXCDailyWeather) -> DateInfo {
        let fullDate = parseFullDate(dailyWeather.datetime)
        
        return DateInfo(
            date: extractDay(from: dailyWeather.datetime),
            weekday: extractWeekday(from: dailyWeather.datetime),
            fullDate: fullDate
        )
    }
    
    // "yyyy-MM-dd" 형식의 문자열을 전체 날짜 문자열로 변환
    private func parseFullDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString) ?? Date()
        
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.locale = Locale(identifier: "ko_KR")
        fullDateFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
        
        return fullDateFormatter.string(from: date)
    }
    
    // 날짜 문자열에서 일자 추출
    private func extractDay(from dateString: String) -> String {
        let components = dateString.split(separator: "-")
        guard components.count == 3 else { return "" }
        return String(components[2])
    }
    
    // 날짜 문자열에서 요일만 추출 (월, 화, 수)
    private func extractWeekday(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        weekdayFormatter.dateFormat = "E"
        
        return weekdayFormatter.string(from: date)
    }
    
    // "HH:mm:ss" 형식의 시간을 Double로 변환 (13.5)
    private func parseTimeToDouble(_ timeString: String) -> Double? {
        let components = timeString.split(separator: ":").compactMap { Double($0) }
        guard components.count >= 2 else { return nil }
        return components[0] + components[1] / 60
    }
    
    private func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
}
