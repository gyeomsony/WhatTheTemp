//
//  HourlyCollectionViewCell.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift

final class HourlyCollectionViewCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIconImageView = IconImageView(name: "clearDay")
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hourLabel,
                                                       weatherIconImageView,
                                                       temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubviews()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .lightGray
    }
    
    private func setupSubviews() {
        addSubview(stackView)
    }
    
    private func setupAutoLayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bind(with data: WeatherSummary, isDaily: Bool) {
        Observable.just(data)
            .map { "\($0.time)\(isDaily ? "일" : "시")" }
            .bind(to: hourLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just(data)
            .map { "\($0.temperature)°" }
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just(data)
            .map { WeatherAssets.getIconName(from: $0.statusCode) }
            .map { UIImage(named: $0) }
            .bind(to: weatherIconImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
