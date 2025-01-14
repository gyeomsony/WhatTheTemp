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
    private let viewModel: SearchViewModel
    private var searchResultViewModel: SearchResultViewModel?
    private var weatherViewModel: WeatherViewModel?
    private var searchListVC: SearchResultListViewController?
    let searchHistoryListView = SearchHistoryView()
    private var refreshControl = UIRefreshControl()
    
    private var searchHistoryData: [SearchHistoryEntity] = [] // CoreData에서 읽어온 데이터

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchListVC)
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    init(viewModel: SearchViewModel, weatherViewModel: WeatherViewModel) {
        self.viewModel = viewModel
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
        
        // 초기화 시 viewModel을 기반으로 searchResultViewModel을 초기화
        searchResultViewModel = SearchResultViewModel(
            addressList: viewModel.addressList.asObservable(),
            searchQuery: viewModel.searchQuery.asObservable())
        
        // searchListVC 초기화
        searchListVC = SearchResultListViewController(viewModel: searchResultViewModel!)
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
        loadSearchHistory() // CoreData에서 데이터 로딩
        loadWeatherData() // 날씨 데이터 로딩
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
    
    // ViewModel에 바인딩
    func bindViewModel() {
        // SearchViewModel에서 데이터를 가져와 SearchResultViewModel에 바인딩
        searchResultViewModel = SearchResultViewModel(
            addressList: viewModel.addressList.asObservable(),
            searchQuery: viewModel.searchQuery.asObservable()
        )
    }
    
    func bindSearchBar() {
        searchController.searchBar.rx.text // 검색창 텍스트 변경 이벤트
            .orEmpty // Optional 제거
            .distinctUntilChanged() // 이전 값과 동일하면 무시
            .filter { !$0.isEmpty } // 비어 있지 않은 값만 처리
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.fetchAddressList(query: query) // API 요청
                self?.searchResultViewModel?.searchText.onNext(query) // 검색어 전달
            })
            .disposed(by: disposeBag)
    }
    
    func loadSearchHistory() {
        // CoreData에서 데이터를 읽어와서 searchHistoryData에 저장
        let coreDataManager = SearchCoreDataManager.shared
        searchHistoryData = coreDataManager.readSearchHistoryData()
        searchHistoryListView.collectionView.reloadData() // 데이터 로딩 후 컬렉션뷰 갱신
    }
    
    func loadWeatherData() {
        // CoreData에서 읽어온 검색 기록을 기반으로 날씨 데이터 로딩
        for history in searchHistoryData {
            let lat = history.lat // CoreData에서 가져온 lat
            let lon = history.lon // CoreData에서 가져온 lon
            
            // 날씨 데이터 요청
            weatherViewModel?.fetchWeatherResponse(lat: lat, lon: lon)
        }
    }
}

// TODO: - Rx로 변경 예정
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("searchHistoryData.count \(searchHistoryData.count)")
        return searchHistoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchHistoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let searchHistory = searchHistoryData[indexPath.row]
        cell.configure(with: searchHistory)
        
        let lat = searchHistory.lat
        let lon = searchHistory.lon
        
        // Observable을 구독하여 셀 업데이트
        weatherViewModel?.fetchWeatherResponseAsObservable(lat: lat, lon: lon)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] current in
                // Current를 CityWeather로 변환
                let cityWeather = current.toCityWeather(cityName: searchHistory.cityName ?? "")
                cell.updateWeatherInfo(current: cityWeather)
            }, onError: { error in
                print("Error fetching weather: \(error)")
                // 여기에 에러 발생 시 처리 로직 추가
            })
            .disposed(by: cell.disposeBag) // 셀 단위로 DisposeBag 관리
        return cell
    }
}
