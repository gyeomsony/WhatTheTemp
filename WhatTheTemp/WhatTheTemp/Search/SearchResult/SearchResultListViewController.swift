//
//  SearchResultListViewController.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit
import RxSwift

final class SearchResultListViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let viewModel: SearchResultViewModel
    let searchResultListView = SearchResultListView()

    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = searchResultListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
}

// MARK: - Private Method
private extension SearchResultListViewController {
    func setupTableView() {
        searchResultListView.tableView.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        searchResultListView.tableView.separatorInset.right = 15
        
        searchResultListView.tableView.rowHeight = UITableView.automaticDimension
        searchResultListView.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        searchResultListView.tableView.register(SearchResultListTableViewCell.self, forCellReuseIdentifier: SearchResultListTableViewCell.reuseIdentifier)
    }
    
    // ViewModel에 바인딩
    func bindViewModel() {
        // ViewModel의 resultList와 테이블 뷰를 바인딩
        viewModel.resultList
            .observe(on: MainScheduler.instance)
            .bind(to: searchResultListView.tableView.rx.items(cellIdentifier: SearchResultListTableViewCell.reuseIdentifier, cellType: SearchResultListTableViewCell.self)) { [weak self] index, item, cell in
                if let cell = cell as? SearchResultListTableViewCell {
                    // item은 (document, searchText) 튜플이므로, 해당 값을 각각 전달
                    cell.configure(query: item.document, searchText: item.searchText)
                }
            }
            .disposed(by: disposeBag)
        
        // 셀 선택 이벤트 처리
        searchResultListView.tableView.rx.modelSelected(KakaoMapModel.Document.self)
            .subscribe(onNext: { document in
                // 셀 선택 후 처리 로직
                print("Selected document: \(document)")
            })
            .disposed(by: disposeBag)
    }
}
