//
//  WeatherViewController.swift
//  WhatTheTemp
//
//  Created by 이명지 on 1/8/25.
//

import UIKit

final class WeatherViewController: UIViewController {
    private var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var pages: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageCollectionView.register(WeatherPageCell.self, forCellWithReuseIdentifier: "WeatherPageCell")
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
    }
}

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherPageCell", for: indexPath) as! WeatherPageCell
    }
}
