//
//  TemperatureChartCell.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import UIKit

import SnapKit
import DGCharts
import RxSwift

final class TemperatureChartCell: UICollectionViewCell {
    static let identifier = "TemperatureChartCell"
    private var disposeBag = DisposeBag()
    
    private let temperatureContentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 12.0
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let weatherIconHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let temperaturelineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.legend.enabled = false
        chartView.setViewPortOffsets(left: 15.0, top: 5.0, right: 30.0, bottom: 5.0)
        chartView.highlightPerDragEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.gridLineDashLengths = [5, 5]
        xAxis.labelCount = 5
        xAxis.axisMinimum = 0.0
        xAxis.axisMaximum = 23.0
        xAxis.forceLabelsEnabled = true
        xAxis.valueFormatter = TimeXAxisValueFormatter()
        xAxis.labelTextColor = .lightGray
        xAxis.centerAxisLabelsEnabled = true
        xAxis.labelPosition = .bottomInside
        
        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.valueFormatter = TemperatureYAxisValueFormatter()
        rightAxis.axisMaximum = 15
        rightAxis.axisMinimum = -25
        rightAxis.labelCount = 8
        rightAxis.labelTextColor = .lightGray
        
        return chartView
    }()
    
    private let precipitationContentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 12.0
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let precipitationLineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.legend.enabled = false
        chartView.setViewPortOffsets(left: 15.0, top: 10.0, right: 30.0, bottom: 5.0)
        chartView.highlightPerDragEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.gridLineDashLengths = [5, 5]
        xAxis.labelCount = 5
        xAxis.axisMinimum = 0.0
        xAxis.axisMaximum = 23.0
        xAxis.forceLabelsEnabled = true
        xAxis.valueFormatter = TimeXAxisValueFormatter()
        xAxis.labelTextColor = .lightGray
        xAxis.centerAxisLabelsEnabled = true
        xAxis.labelPosition = .bottomInside
        
        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        
        let rightAxis = chartView.rightAxis
        rightAxis.valueFormatter = PercentageYAxisValueFormatter()
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = -20
        rightAxis.labelCount = 8
        rightAxis.labelTextColor = .lightGray
        
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
        self.setupLongPressGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.temperaturelineChartView.data = nil
        self.weatherIconHStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: TemperatureCharCellViewModel) {
        viewModel.temperatureEntries
            .drive(onNext: { [weak self] entries in
                self?.configureLineChart(entris: entries)
            }).disposed(by: disposeBag)
        
        viewModel.weatherIcons
            .drive(onNext: { [weak self] icons in
                self?.configureWeatherIcons(icons: icons)
            }).disposed(by: disposeBag)
        
        viewModel.precipitationEntries
            .drive(onNext: { [weak self] precipitations in
                self?.configurePrecipitationLineChart(entries: precipitations)
            }).disposed(by: disposeBag)
    }
    
    private func configureLineChart(entris: [ChartEntry]) {
        let chartEntries = entris.map { ChartDataEntry(x: $0.x, y: $0.y) }
        let dataSet = LineChartDataSet(entries: chartEntries, label: "Cubic Line Data")
    
        dataSet.mode = .cubicBezier
        
        dataSet.lineWidth = 4.0
        dataSet.setColor(UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0))
        
        guard let maxEntry = chartEntries.max(by: { $0.y < $1.y }),
              let minEntry = chartEntries.min(by: { $0.y < $1.y }) else { return }
        
        dataSet.circleRadius = 5.0
        dataSet.circleHoleRadius = 2.0
        dataSet.circleHoleColor = UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0)
        dataSet.circleColors = chartEntries.map { $0 == maxEntry || $0 == minEntry ? .black : .clear }
        dataSet.valueFormatter = CustomValueFormatter(maxEntry: maxEntry, minEntry: minEntry)
        dataSet.valueFont = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        dataSet.valueTextColor = .gray
        
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)
        dataSet.fillAlpha = 0.8
        dataSet.axisDependency = .right
        dataSet.fillFormatter = DefaultFillFormatter { _, _ in CGFloat(-20) }
        
        let chartData = LineChartData(dataSet: dataSet)
        temperaturelineChartView.data = chartData
        temperaturelineChartView.notifyDataSetChanged()
    }
    
    private func configureWeatherIcons(icons: [String]) {
        weatherIconHStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        icons.forEach { iconName in
            let imageView = UIImageView(image: UIImage(named: iconName))
            imageView.contentMode = .scaleAspectFit
            weatherIconHStackView.addArrangedSubview(imageView)
        }
    }
    
    private func configurePrecipitationLineChart(entries: [ChartEntry]) {
        let chartEntries = entries.map { ChartDataEntry(x: $0.x, y: $0.y) }
        let dataSet = LineChartDataSet(entries: chartEntries, label: "Linear Line Data")
        
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 4.0
        dataSet.setColor(UIColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 1.0))
        dataSet.drawCirclesEnabled = false
        dataSet.circleRadius = 0.0
        
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)
        dataSet.fillAlpha = 0.8
        dataSet.axisDependency = .right
        dataSet.fillFormatter = DefaultFillFormatter { _, _ in CGFloat(0) }
        
        let chartData = LineChartData(dataSet: dataSet)
        precipitationLineChartView.data = chartData
        precipitationLineChartView.notifyDataSetChanged()
    }
    
    private func configureUI() {
        [temperatureContentView, precipitationContentView].forEach { contentView.addSubview($0) }
        
        [weatherIconHStackView, temperaturelineChartView].forEach { temperatureContentView.addSubview($0) }
        
        precipitationContentView.addSubview(precipitationLineChartView)
    }
    
    private func setupConstraints() {
        temperatureContentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 3.0)
        }
        
        weatherIconHStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(35.0)
            $0.height.equalTo(30.0)
        }
        
        temperaturelineChartView.snp.makeConstraints {
            $0.top.equalTo(weatherIconHStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
        
        precipitationContentView.snp.makeConstraints {
            $0.top.equalTo(temperatureContentView.snp.bottom).offset(20.0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height / 3.0)
        }
        
        precipitationLineChartView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5.0)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.2
        temperaturelineChartView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: temperaturelineChartView)
        
        switch gesture.state {
        case .began, .changed:
            let highlight = temperaturelineChartView.getHighlightByTouchPoint(location)
            temperaturelineChartView.highlightValue(highlight)
        case .ended, .cancelled:
            temperaturelineChartView.highlightValue(nil)
        default:
            break
        }
    }
}

// MARK: - Formatter classes.
final class TemperatureYAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        // Y축 값이 -25인 경우 빈 문자열 반환(라벨 생략)
        // 그 외의 경우, 값에 "°"를 추가하여 반환 (정수로 변환)
        value == -25 ? "" : "\(Int(value))°"
    }
}

final class TimeXAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        var intValue = Int(value)
        
        if intValue != 0 { intValue += 1 }
        
        // 특정 시간대(0, 6, 12, 18)에만 라벨 표시
        switch intValue {
        case 0:
            return "오전 12시"
        case 6:
            return "오전 6시"
        case 12:
            return "오후 12시"
        case 18:
            return "오후 6시"
        default:
            return "" // 그 외 시간은 빈 문자열
        }
    }
}

/// 데이터 엔트리에 따라 "최고", "최저" 라벨 표시하는 커스텀 값 포멧터
/// - 주어진 데이터에서 최대값과 최소값 엔트리에 라벨 부여
final class CustomValueFormatter: ValueFormatter {
    private let maxEntry: ChartDataEntry
    private let minEntry: ChartDataEntry
    
    init(maxEntry: ChartDataEntry, minEntry: ChartDataEntry) {
        self.maxEntry = maxEntry
        self.minEntry = minEntry
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        entry == maxEntry ? "최고" : entry == minEntry ? "최저" : ""
    }
}
