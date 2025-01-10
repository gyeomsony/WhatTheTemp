//
//  SearchHistoryView.swift
//  WhatTheTemp
//
//  Created by t2023-m0019 on 1/9/25.
//

import UIKit
import SnapKit

final class SearchHistoryView: UIView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchHistoryView {
    func setupUI() {
        addSubview(collectionView)
    }
    
    func setupConstraint() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        
        return layout
    }
}
