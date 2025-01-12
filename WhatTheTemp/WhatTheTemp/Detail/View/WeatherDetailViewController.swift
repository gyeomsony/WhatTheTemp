//
//  WeatherDetailViewController.swift
//  WhatTheTemp
//
//  Created by 전성규 on 1/11/25.
//

import UIKit

import SnapKit
import RxSwift
import RxDataSources

final class WeatherDetailViewController: UIViewController {
    private let viewModel: WeatherDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - SubViews.
    private let navigationBar = WeatherDetailNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.register(DateSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DateSectionFooterView.identifier)
        
        collectionView.register(TemperatureChartCell.self, forCellWithReuseIdentifier: TemperatureChartCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - DataSource.
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(
        configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .date(let dateInfo):
                guard let dateCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DateCell.identifier,
                    for: indexPath) as? DateCell else { return UICollectionViewCell() }
                dateCell.configure(with: dateInfo)
                
                return dateCell
            case .temp(let temperatureInfo):
                guard let temperatureChartCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TemperatureChartCell.identifier,
                    for: indexPath) as? TemperatureChartCell else { return UICollectionViewCell() }
                temperatureChartCell.configureLineChart(from: temperatureInfo)
                
                return temperatureChartCell
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let section = dataSource[indexPath.section]
            
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                if let firstItem = section.items.first, case .date = firstItem {
                    guard let dateFooter = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: DateSectionFooterView.identifier,
                        for: indexPath
                    ) as? DateSectionFooterView else { return UICollectionReusableView() }
                    dateFooter.configure(with: section.footer ?? "")
                    return dateFooter
                }
            default: return UICollectionReusableView() }
            
            return UICollectionReusableView()
        })
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
        self.configureUI()
        self.setupConstraints()
    }
    
    // MARK: - Binding method.
    private func bindViewModel() {
        Observable.just(())
            .bind(to: viewModel.viewDidLoadTrigger)
            .disposed(by: disposeBag)
        
        viewModel.weatherSections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - View layout method.
    private func configureUI() {
        view.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        view.addSubViews([navigationBar, collectionView])
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - CompotitionalLayout method.
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] index, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch index {
            case 0:
                return createDateSection()
            case 1:
                return createTemperatureSection()
            default:
                return nil
            }
        }
    }

    private func createDateSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.14),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .fixed(10),
                top: nil,
                trailing: nil,
                bottom: nil
            )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50.0))
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createTemperatureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0.0,
            leading: 10.0,
            bottom: 0.0,
            trailing: 10.0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(UIScreen.main.bounds.height / 3.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}

#if DEBUG

import SwiftUI

struct WeatherDetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var showModal = false
        
        var body: some View {
            Button("Show Weather Detail") {
                showModal = true
            }
            .sheet(isPresented: $showModal) {
                WeatherDetailViewController_Presentable()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    struct WeatherDetailViewController_Presentable: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let vm = WeatherDetailViewModel(repository: WeatherRepository())
            let vc = WeatherDetailViewController(viewModel: vm)
            return vc
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}

#endif


