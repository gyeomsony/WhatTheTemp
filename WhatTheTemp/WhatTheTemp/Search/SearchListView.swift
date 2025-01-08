//
//  SearchListView.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/8/25.
//

import UIKit
import SnapKit

final class SearchListView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchListView {
    func setupUI() {
        addSubview(tableView)
    }
    
    func setupConstraint() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset.right = 15
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(SearchListTableViewCell.self, forCellReuseIdentifier: SearchListTableViewCell.reuseIdentifier)
    }
}

extension SearchListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListTableViewCell.reuseIdentifier, for: indexPath) as? SearchListTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
