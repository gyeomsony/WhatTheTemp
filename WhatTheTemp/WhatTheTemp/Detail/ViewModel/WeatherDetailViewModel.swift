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
    
    private let selectedDateCellID = BehaviorRelay<String?>(value: nil)
    let dateSectionFooterData = BehaviorRelay<String?>(value: nil)
    
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
                    .withUnretained(self)
                    .map { vm, response in
                        let dateSection = self.createDateSection(from: response)
                        let weatherSection = self.createWeatherSection(from: response)
                        
                        // 첫 번째 셀 기본 선택 상태 설정
                        if let firstDateCellViewModel = dateSection.items.first,
                           case let .date(dateCellViewModel) = firstDateCellViewModel {
                            vm.selectedDateCellID.accept(dateCellViewModel.dateInfo.id)
                            vm.dateSectionFooterData.accept(dateCellViewModel.dateInfo.fullDate)
                        }
                    
                        return [dateSection, weatherSection]
                    }
            }.bind(to: weatherSections)
            .disposed(by: disposeBag)
        
        // 선택된 Cell ID가 변경되었을 때 Footer 날짜 업데이트
        selectedDateCellID
            .withLatestFrom(weatherSections) { selectedID, sections -> String? in
                guard let selectedID = selectedID else { return nil }
                let dateSection = sections.first(where: { $0.header == nil })
                guard let items = dateSection?.items else { return nil }
                
                for item in items {
                    if case let .date(dateCellViewModel) = item,
                       dateCellViewModel.dateInfo.id == selectedID {
                        return dateCellViewModel.dateInfo.fullDate
                    }
                }
                
                return nil
            }.bind(to: dateSectionFooterData)
            .disposed(by: disposeBag)
    }
    
    // 특정 ID의 셀을 선택 상태로 업데이트
    func selectCell(with id: String) { selectedDateCellID.accept(id) }
    
    // 차트 인덱스를 기반으로 선택된 날짜 셀 ID를 업데이트
    func updateSelectedCellID(forChartIndex index: Int) {
        let sections = weatherSections.value
        guard let dateSection = sections.first(where: { $0.header == nil }) else { return }
        
        let items = dateSection.items
        if index < items.count,
           case let .date(DateCellViewModel) = items[index] {
            selectedDateCellID.accept(DateCellViewModel.dateInfo.id)
        }
    }
    
    // 선택된 날짜 셀 ID를 기반으로 차트의 인덱스를 반환
    func convertChartIndex(forDateCellID id: String?) -> Int? {
        guard let id = id else { return nil }
        let sections = weatherSections.value
        guard let dateSection = sections.first(where: { $0.header == nil }) else { return nil }
        
        for (index, item) in dateSection.items.enumerated() {
            if case let .date(DateCellViewModel) = item,
               DateCellViewModel.dateInfo.id == id { return index }
        }
        
        return nil
    }
    
    // MARK: - Private Helper Methods
    
    // 공통적인 섹션 생성을 처리하는 제너릭 함수
    private func createSection<T, VM>(from items: [T], mapToViewModel: (T) -> VM, sectionItemMapper: (VM) -> SectionItem) -> SectionModel {
        let viewModels = items.map(mapToViewModel).map(sectionItemMapper)
        return SectionModel(header: nil, footer: nil, items: viewModels)
    }

    // 날짜 섹션 생성
    private func createDateSection(from response: VXCWeatherResponse) -> SectionModel {
        return createSection(
            from: response.days,
            mapToViewModel: createDateCellViewModel,
            sectionItemMapper: SectionItem.date
        )
    }

    // 날씨 정보를 기반으로 차트 섹션 생성
    private func createWeatherSection(from response: VXCWeatherResponse) -> SectionModel {
        return createSection(
            from: response.days,
            mapToViewModel: { day in
                let times = day.hours.compactMap { self.parseTimeToDouble($0.datetime) }
                let temperatures = day.hours.map { $0.temp }
                let conditions = day.hours.enumerated()
                    .filter { $0.offset % 2 != 0 }
                    .prefix(12)
                    .map { $0.element.conditions }
                let precipitation = day.hours.map { $0.precipitationProbability }
                
                let temperatureInfo = TemperatureInfo(
                    date: day.datetime,
                    times: times,
                    temperature: temperatures,
                    conditions: conditions,
                    precipitation: precipitation
                )
                return TemperatureCharCellViewModel(temperatureInfo: temperatureInfo)
            },
            sectionItemMapper: SectionItem.temp
        )
    }

    private func createDateCellViewModel(from dailyWeather: VXCDailyWeather) -> DateCellViewModel {
        let fullDate = parseFullDate(dailyWeather.datetime)
        let dateInfo = (DateInfo(
            id: UUID().uuidString,
            date: extractDay(from: dailyWeather.datetime),
            weekday: extractWeekday(from: dailyWeather.datetime),
            fullDate: fullDate))
        
        let isSelcted = selectedDateCellID
            .map { $0 == dateInfo.id }
            .distinctUntilChanged()
        
        return DateCellViewModel(dateInfo: dateInfo, isSelected: isSelcted)
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
