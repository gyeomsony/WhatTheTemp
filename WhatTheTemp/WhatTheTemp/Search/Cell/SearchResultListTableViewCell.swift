//
//  SearchResultListTableViewCell.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/8/25.
//

import UIKit

final class SearchResultListTableViewCell: UITableViewCell, ReuseIdentifying {
    private let cityName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
        label.text = "대한민국 서울특별시"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
