//
//  WeatherViewController.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let weatherViewModel = WeatherViewModel(repository: WeatherRepository())
    
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
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    // 테스트로 2페이지 설정
    private var pages: [Int] = [0, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupNotificationObservers()
        
    }
    // 앱의 온도 단위 설정 변경을 감지하고 메뉴 UI를 업데이트
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenu), name: .tempUnitChanged, object: nil)
    }
    // 설정 버튼의 메뉴를 현재 온도 단위에 맞게 재생성 후 업데이트
    @objc private func updateMenu() {
        if let settingsButton = navigationItem.leftBarButtonItem {
            settingsButton.menu = MenuHelper.createSettingsMenu()
        }
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
    
    func addPage() {
        let newIndex = pages.count
        pages.append(newIndex)
        pageCollectionView.reloadData()
        
        let indexPath = IndexPath(item: newIndex, section: 0)
        pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        // 메뉴 헬퍼
        settingsButton.menu = MenuHelper.createSettingsMenu()
        navigationItem.leftBarButtonItem = settingsButton
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupViewModel() {
        weatherViewModel.fetchWeatherResponse(lat: 37.5665, lon: 126.9780)
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        view.frame.size
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherPageCell", for: indexPath) as? WeatherPageCell else {
            return UICollectionViewCell()
        }
        cell.weatherView.bind(to: weatherViewModel)
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}
