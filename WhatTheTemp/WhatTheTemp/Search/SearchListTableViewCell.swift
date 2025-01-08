//
//  SearchListTableViewCell.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/8/25.
//

import UIKit

final class SearchListTableViewCell: UITableViewCell, ReuseIdentifying {
    private let cityName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .blue
        label.text = "대한민국 서울특별시"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchListTableViewCell {
    func setupUI() {
        addSubview(cityName)
    }
    
    func setupConstraint() {
        cityName.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(15)
        }
    }
}
