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
            .bind(to: searchResultListView.tableView.rx.items(cellIdentifier: SearchResultListTableViewCell.reuseIdentifier, cellType: SearchResultListTableViewCell.self)) { index, document, cell in
                cell.configure(query: document) // 셀 데이터 설정
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
