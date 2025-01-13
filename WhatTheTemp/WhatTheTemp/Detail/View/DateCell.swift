//
//  DateCell.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import UIKit

import SnapKit
import RxSwift

final class DateCell: UICollectionViewCell {
    static let identifier = "DateCell"
    private var disposeBag = DisposeBag()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        label.layer.cornerRadius = 44.0 / 2
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: DateCellViewModel) {
        // DisposeBag 초기화: 재사용될 때 구독 해제
        disposeBag = DisposeBag()
        
        viewModel.weekdayText
            .bind(to: weekdayLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateText
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { c, selected in
                c.dateLabel.textColor = selected ? .black : .white
                c.dateLabel.backgroundColor = selected ? .white : .clear
            }).disposed(by: disposeBag)
    }
    
    private func configureUI() {
        contentView.addSubViews([weekdayLabel, dateLabel])
    }
    
    private func setupConstraints() {
        weekdayLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(20.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(weekdayLabel.snp.bottom).offset(5.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44.0)
        }
    }
}
