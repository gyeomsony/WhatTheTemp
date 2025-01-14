//
//  SearchHistoryView.swift
//  WhatTheTemp
//
//  Created by 박시연 on 1/9/25.
//

import UIKit
import SnapKit

final class SearchHistoryView: UIView {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()
    
    // 삭제 액션을 뷰 컨트롤러에 전달하는 클로저
    var onDeleteAction: ((IndexPath) -> Void)?
    
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
    
//    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//        // UICollectionLayoutListConfiguration 사용
//        var config = UICollectionLayoutListConfiguration(appearance: .plain)
//        config.showsSeparators = false // 구분선 숨김
//        config.trailingSwipeActionsConfigurationProvider = { indexPath in
//            // 셀 오른쪽 스와이프 동작 정의 (예: 삭제)
//            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
//                // 셀 삭제 동작 처리
//                completion(true)
//            }
//            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
//            return swipeActions
//        }
//        
//        // UICollectionViewCompositionalLayout 사용
//        let layout = UICollectionViewCompositionalLayout.list(using: config)
//        return layout
//    }
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false // 구분선 숨김
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self else { return nil }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
                // 셀 삭제 동작을 뷰컨트롤러에 전달
                self.onDeleteAction?(indexPath)
                completion(true)
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeActions
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
