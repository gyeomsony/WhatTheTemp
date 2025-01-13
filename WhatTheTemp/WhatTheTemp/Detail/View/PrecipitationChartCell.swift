//
//  PrecipitationChartCell.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/12/25.
//

import UIKit

import SnapKit
import DGCharts
import RxSwift

final class PrecipitationChartCell: UICollectionViewCell {
    static let identifier = "PrecipitationChartCell"
    private let disposeBag = DisposeBag()
    
    private let lineChartView: LineChartView = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: PrecipitationChartCellViewModel) {
        viewModel.precipitationEntries
            .drive(onNext: { [weak self] entries in
                self?.configureLineChart(entries: entries)
            }).disposed(by: disposeBag)
    }
    
    private func configureLineChart(entries: [ChartEntry]) {
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
        lineChartView.data = chartData
    }
    
    private func configureUI() {
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
        
        addSubview(lineChartView)
    }
    
    private func setupConstraints() {
        lineChartView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5.0)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

final class PercentageYAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        value == -20 ? "" : "\(Int(value))%"
    }
}
