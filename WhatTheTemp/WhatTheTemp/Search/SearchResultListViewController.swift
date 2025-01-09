//
//  SearchResultListViewController.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit

final class SearchResultListViewController: UIViewController {
    var searchQuery: String?
    let searchResultListView = SearchResultListView()
    var addressList: [KakaoMapModel.Document] = []

    override func loadView() {
        super.loadView()
        self.view = searchResultListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateResult(addressList)
    }
    
    func setupTableView() {
        searchResultListView.tableView.delegate = self
        searchResultListView.tableView.dataSource = self
        searchResultListView.tableView.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        searchResultListView.tableView.separatorInset.right = 15
        
        searchResultListView.tableView.rowHeight = UITableView.automaticDimension
        searchResultListView.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        searchResultListView.tableView.register(SearchResultListTableViewCell.self, forCellReuseIdentifier: SearchResultListTableViewCell.reuseIdentifier)
    }
    
    // 검색 결과를 업데이트하는 메서드
    func updateResult(_ results: [KakaoMapModel.Document]) {
        self.addressList = results
        searchResultListView.tableView.reloadData() // 테이블 뷰를 갱신
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Method
extension SearchResultListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultListTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultListTableViewCell else {
            return UITableViewCell()
        }
        
        let document = addressList[indexPath.row]
        cell.configure(query: document)
        return cell
    }
}
