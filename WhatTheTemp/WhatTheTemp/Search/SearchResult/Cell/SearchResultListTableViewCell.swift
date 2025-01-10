//
//  SearchResultListTableViewCell.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit
import SnapKit

final class SearchResultListTableViewCell: UITableViewCell, ReuseIdentifying {
    private let cityName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(query: KakaoMapModel.Document) {
        cityName.text = query.addressName
    }
}

private extension SearchResultListTableViewCell {
    func setupUI() {
        addSubview(cityName)
    }
    
    func setupConstraint() {
        cityName.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(15)
        }
    }
}