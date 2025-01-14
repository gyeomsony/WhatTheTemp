//
//  WeatherViewController.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit
import RxSwift

final class WeatherViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: WeatherViewModel
    private let coreDataManager = SearchCoreDataManager.shared
    private let userDefaults = UserDefaults.standard
    private let lastPageKey = "LastViewedPageIndex"
    
    private var pages: [SearchHistoryEntity] = [] {
        didSet {
            pageControl.numberOfPages = pages.count + 1
            pageCollectionView.reloadData()
        }
    }
    
    // Bool값을 사용해서 현재 온도를 관리하고 기본값은 "섭씨"로 함
    // UserDefaults를 사용해 선택 상태가 앱이 재실행 되더라도 유지가 됨
    private var isCelsius: Bool = true {
        didSet {
            updateTemperatureUnit()
        }
    }
    
    private var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeatherPageCell.self, forCellWithReuseIdentifier: "WeatherPageCell")
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count + 1
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPages()
        scrollToLastViewedPage()
        updateTemperatureUnit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                           style: .plain,
                                           target: self,
                                           action: nil)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                             style: .plain,
                                             target: self,
                                             action: nil)
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.leftBarButtonItem = settingsButton
        
        updateMenu()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false // 반투명 해제
    }
    
    // 설정 메뉴로 온도 단위 전환
    private func updateMenu() {
        navigationItem.leftBarButtonItem?.menu = createSettingsMenu()
    }
    
    private func createSettingsMenu() -> UIMenu {
        let celsiusAction = UIAction(
            title: "섭씨",
            image: UIImage(systemName: "degreesign.celsius"),
            state: isCelsius ? .on : .off
        ) { [weak self] _ in
            self?.isCelsius = true
        }

        let fahrenheitAction = UIAction(
            title: "화씨",
            image: UIImage(systemName: "degreesign.fahrenheit"),
            state: isCelsius ? .off : .on
        ) { [weak self] _ in
            self?.isCelsius = false
        }

        return UIMenu(title: "온도 설정", children: [celsiusAction, fahrenheitAction])
    }
    
    // 온도 변환과 UI업데이트 진행
    private func updateTemperatureUnit() {
        updateMenu() // 메뉴 상태 업데이트 해서 체크표시 유지
        for cell in pageCollectionView.visibleCells {
            if let weatherCell = cell as? WeatherPageCell {
                weatherCell.weatherView.updateTemperatureUnit(isCelsius: isCelsius)
            }
        }
    }
    
    private func loadPages() {
        pages = coreDataManager.readSearchHistoryData()
    }
    
    private func scrollToLastViewedPage() {
        let lastPageIndex = userDefaults.integer(forKey: lastPageKey)
        if lastPageIndex < pages.count {
            let indexPath = IndexPath(item: lastPageIndex, section: 0)
            pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = lastPageIndex
        }
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherPageCell", for: indexPath) as? WeatherPageCell else {
            return UICollectionViewCell()
        }
        cell.weatherView.bind(to: viewModel)
        cell.weatherView.updateTemperatureUnit(isCelsius: isCelsius) // 초기 값 전달
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentPage
        
        userDefaults.set(currentPage, forKey: lastPageKey)
    }
}
