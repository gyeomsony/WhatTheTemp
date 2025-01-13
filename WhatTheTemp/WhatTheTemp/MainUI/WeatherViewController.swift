//
//  WeatherViewController.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    
    // Bool값을 사용해서 현재 온도를 관리하고 기본값은 "섭씨"로 함
    // UserDefaults를 사용해 선택 상태가 앱이 재실행 되더라도 유지가 됨
    private var isCelsius: Bool = UserDefaults.standard.object(forKey: "isCelsius") as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(isCelsius, forKey: "isCelsius")
            updateTemperatureUnit()
        }
    }
    // 테스트로 2페이지 설정
    private var pages: [Int] = [0, 1]
    
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
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupViewModel()
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
        
        updateMenu()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
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
    private func setupViewModel() {
        viewModel.fetchWeatherResponse(lat: 37.5665, lon: 126.9780)
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
        cell.weatherView.bind(to: viewModel)
        cell.weatherView.updateTemperatureUnit(isCelsius: isCelsius) // 초기 값 전달
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = currentPage
    }
}
