//
//  DateSectionFooterView.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import UIKit

import SnapKit

final class DateSectionFooterView: UICollectionReusableView {
    static let identifier = "DateSectionFooterView"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dateString: String) { dateLabel.text = dateString }
    
    private func configureUI() { addSubViews([dateLabel, separatorLine]) }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        separatorLine.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10.0)    // 밑에 배치될 Section과의 간격
            $0.height.equalTo(0.5)
        }
    }
}
