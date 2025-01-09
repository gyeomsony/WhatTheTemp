//
//  SearchViewController.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private lazy var searchListVC = SearchResultListViewController()
    private let viewModel: SearchViewModel
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchListVC)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        setupNavigationBar()
        setupSearchController()
        bindViewModel()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "날씨"
        // navigationBar Large 타이틀 텍스트 색상 설정
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupSearchController() {
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barTintColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1.0) // 검색창 바 색상 변경
        
        // Placeholder 텍스트 색상 설정
        let textField = searchController.searchBar.searchTextField
        textField.attributedPlaceholder = NSAttributedString(
            string: "도시명, 우편번호를 입력해주세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)]
        )
        // 입력 텍스트 색상 설정
        textField.textColor = UIColor.white
        
        // 돋보기 아이콘 색상 변경
        if let leftView = textField.leftView as? UIImageView {
            leftView.tintColor = UIColor.white
        }
        
        // Cancel 버튼 스타일 변경
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal
        )
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText") // "Cancel" 텍스트를 "취소"로 변경
    }
    
    // ViewModel에 바인딩
    func bindViewModel() {
        viewModel.addressList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] addressList in
                self?.searchListVC.updateResult(addressList)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UISearchResultsUpdating Method
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        viewModel.fetchAddressList(query: query) // 검색 결과 업데이트
    }
}
