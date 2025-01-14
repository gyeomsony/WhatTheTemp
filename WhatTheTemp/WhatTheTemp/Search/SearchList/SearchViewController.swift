//
//  SearchViewController.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/8/25.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let searchViewModel: SearchViewModel
    private var searchResultViewModel: SearchResultViewModel
    private var searchHistoryViewModel: SearchHistoryViewModel?
    private var searchResultVC: SearchResultListViewController?
    let searchHistoryListView = SearchHistoryView()
    private var refreshControl = UIRefreshControl()
    
    private var cityWeathers: [CityWeather] = [] // CoreData에서 읽어온 데이터

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    init(viewModel: SearchViewModel, searchHistoryViewModel: SearchHistoryViewModel, searchResultViewModel: SearchResultViewModel) {
        self.searchViewModel = viewModel
        self.searchHistoryViewModel = searchHistoryViewModel
        self.searchResultViewModel = searchResultViewModel
        super.init(nibName: nil, bundle: nil)
        
        // Initialize searchResultVC with searchResultViewModel
        searchResultVC = SearchResultListViewController(resultViewModel: searchResultViewModel, searchViewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = searchHistoryListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        setupRefreshControl()
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
        bindViewModel()
        bindSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindCollectionViewCell()
    }
}

// MARK: - Private Method

private extension SearchViewController {
    func setupRefreshControl() {
        // refreshControl property에 UIRefreshControl() 할당
        searchHistoryListView.collectionView.refreshControl = UIRefreshControl()
        searchHistoryListView.collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        searchHistoryListView.collectionView.refreshControl?.tintColor = .white
    }
    
    @objc
    func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.searchHistoryListView.collectionView.reloadData()
            self.searchHistoryListView.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "날씨"

        navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = true

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
    
    func setupCollectionView() {
        searchHistoryListView.collectionView.delegate = self
        searchHistoryListView.collectionView.dataSource = self
        
        searchHistoryListView.collectionView.register(SearchHistoryCollectionViewCell.self, forCellWithReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier)
    }
    
    // 각 셀에 해당하는 데이터 바인딩
    func bindCollectionViewCell() {
        searchHistoryViewModel?.cityWeathers
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, cityWeathers in
                vc.cityWeathers = cityWeathers
                vc.searchHistoryListView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // ViewModel에 바인딩
    func bindViewModel() {
        // SearchViewModel에서 데이터를 가져와 SearchResultViewModel에 바인딩
        searchResultViewModel = SearchResultViewModel(
            addressList: searchViewModel.addressList.asObservable(),
            searchQuery: searchViewModel.searchQuery.asObservable()
        )
    }
    
    func bindSearchBar() {
        searchController.searchBar.rx.text // 검색창 텍스트 변경 이벤트
            .orEmpty // Optional 제거
            .distinctUntilChanged() // 이전 값과 동일하면 무시
            .filter { !$0.isEmpty } // 비어 있지 않은 값만 처리
            .subscribe(onNext: { [weak self] query in
                self?.searchViewModel.fetchAddressList(query: query) // API 요청
                self?.searchResultViewModel.searchText.onNext(query) // 검색어 전달
            })
            .disposed(by: disposeBag)
    }
}

// TODO: - Rx로 변경 예정
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchHistoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let weather = cityWeathers[indexPath.row]
        cell.configure(with: weather)
        
        return cell
    }
    
    // 셀을 탭했을 때 화면 pop
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
