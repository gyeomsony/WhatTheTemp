//
//  SearchResultListViewController.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultListViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let resultViewModel: SearchResultViewModel
    private let searchViewModel: SearchViewModel
    let searchResultListView = SearchResultListView()

    init(resultViewModel: SearchResultViewModel, searchViewModel: SearchViewModel) {
        self.resultViewModel = resultViewModel
        self.searchViewModel = searchViewModel
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
        bindTableViewCellSelection()
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
        // 검색 결과와 검색어를 결합한 데이터를 ViewModel의 resultList와 테이블 뷰를 바인딩
        searchViewModel.addressList
            .observe(on: MainScheduler.instance)
            .bind(to: searchResultListView.tableView.rx.items(cellIdentifier: SearchResultListTableViewCell.reuseIdentifier)) { [weak self] (index, item, cell: SearchResultListTableViewCell) in
                guard let self = self else { return }
                
                // (문서, 검색어) tuple로 셀을 구성
                let searchText = self.searchViewModel.searchQuery.value
                cell.configure(query: item.addressName ?? "", searchText: searchText)
            }
            .disposed(by: disposeBag)
    }
    
    // 셀 선택시 CoreData에 데이터 저장 이벤트 처리
    func bindTableViewCellSelection() {
        searchResultListView.tableView.rx.modelSelected(KakaoMapModel.Document.self)
            .subscribe(onNext: { [weak self] document in
                guard let self = self else { return }
                self.resultViewModel.saveSearchHistory(document: document)
                
                if let searchViewController = self.presentingViewController as? SearchViewController {
                    searchViewController.searchController.searchBar.text = ""
                    searchViewController.searchController.searchBar.endEditing(true)
                    searchViewController.navigationController?.popViewController(animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}
