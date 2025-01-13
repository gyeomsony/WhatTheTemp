//
//  WeatherRepository.swift
//  WhatTheTemp
//
//  Created by 손겸 on 1/9/25.
//

import Foundation
import RxMoya
import Moya
import RxSwift

protocol WeatherRepositoryProtocol {
    // OpenWeather API
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse>
    
    // Visual Crossing API
    func fetchVXCWeatherData(location: String, startDate: String, endDate: String) -> Single<VXCWeatherResponse>
    func fetchWeathers(coordinates: [(lat: Double, lon: Double)]) -> Single<[WeatherResponse]>


final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = MoyaProvider<WeatherAPI>()
    
    /// 단일 좌표에 대한 단일 날씨 데이터 반환
    func fetchWeather(lat: Double, lon: Double) -> Single<WeatherResponse> {
        return provider.rx.request(.oneCall(lat: lat, lon: lon))
            .map(WeatherResponse.self)
    }
    
    
    func fetchVXCWeatherData(location: String, startDate: String, endDate: String) -> Single<VXCWeatherResponse> {
        return provider.rx.request(.visualCrossing(location: location, startDate: startDate, endDate: endDate))
            .map(VXCWeatherResponse.self)
    /// 여러개의 좌표를 배열로 받아 그에 대응하는 날씨 데이터의 배열을 반환
    func fetchWeathers(coordinates: [(lat: Double, lon: Double)]) -> Single<[WeatherResponse]> {
        let requests = coordinates.map { (lat, lon) in
            fetchWeather(lat: lat, lon: lon)
        }
        
        /// zip : 입력 순서와 동일한 순서로 결과를 방출하는 것을 보장
        return Single.zip(requests) { responses in
            return responses
        }
    }
}
