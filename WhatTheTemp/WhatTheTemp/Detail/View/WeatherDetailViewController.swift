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
    private var isInitialScrollPerformed = false
    
    private let navigationBar = WeatherDetailNavigationBar()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.register(DateSectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DateSectionFooterView.identifier)
        
        collectionView.register(TemperatureChartCell.self, forCellWithReuseIdentifier: TemperatureChartCell.identifier)
        collectionView.register(PrecipitationChartCell.self, forCellWithReuseIdentifier: PrecipitationChartCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - DataSource.
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(
        configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .date(let dateCellViewModel):
                guard let dateCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DateCell.identifier,
                    for: indexPath) as? DateCell else { return UICollectionViewCell() }
                dateCell.bind(to: dateCellViewModel)
                
                return dateCell
            case .temp(let chartCellViewModel):
                guard let temperatureChartCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TemperatureChartCell.identifier,
                    for: indexPath) as? TemperatureChartCell else { return UICollectionViewCell() }
                temperatureChartCell.bind(to:chartCellViewModel)
                
                return temperatureChartCell
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            let section = dataSource[indexPath.section]
            
            switch kind {
            case UICollectionView.elementKindSectionFooter:
                if let firstItem = section.items.first, case .date = firstItem {
                    guard let dateFooter = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: DateSectionFooterView.identifier,
                        for: indexPath
                    ) as? DateSectionFooterView else { return UICollectionReusableView() }
                    let section = dataSource.sectionModels[indexPath.section]
                    
                    if let footerText = self?.viewModel.dateSectionFooterData.value {
                        dateFooter.configure(with: footerText)
                    }
                    
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
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { vc, indexPath in
                let item = vc.dataSource[indexPath]
                switch item {
                case .date(let dateCellViewModel):
                    vc.viewModel.selectCell(with: dateCellViewModel.dateInfo.id)
                    vc.updateFooter()
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { $0.section == 0 }
            .withUnretained(self)
            .compactMap { vc, indexPath -> Int? in
                let item = vc.dataSource[indexPath]
                guard case let .date(dateCellViewModel) = item else { return nil }
                
                return vc.viewModel.convertChartIndex(forDateCellID: dateCellViewModel.dateInfo.id)
            }.withUnretained(self)
            .subscribe(onNext: { vc, chartIndex in
                let indexPath = IndexPath(item: chartIndex, section: 1)
                vc.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func updateFooter() {
        guard let footerView = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: 0)) as? DateSectionFooterView else { return }
        
        if let footerText = viewModel.dateSectionFooterData.value {
            footerView.configure(with: footerText)
        }
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
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]index, _  in
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
        
        return layout
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
            heightDimension: .absolute(UIScreen.main.bounds.height / 1.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = []
        section.orthogonalScrollingBehavior = .paging
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0.0,
            leading: 0.0,
            bottom: 20.0,
            trailing: 0.0
        )
        
        // 가로 스크롤 이벤트 감지
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, layoutEnvironment in
            guard let self = self else { return }
            
            // 초기 스크롤 방지
            if !self.isInitialScrollPerformed { return self.isInitialScrollPerformed = true }
            
            let pageIndex = Int(round(contentOffset.x / layoutEnvironment.container.contentSize.width))
            
            Observable.just(pageIndex)
                .distinctUntilChanged()
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] throttledIndex in
                    guard let self = self else { return }
                    self.viewModel.updateSelectedCellID(forChartIndex: throttledIndex)
                    
                    // 날짜 섹션 스크롤 동기화
                    let dateSectionIndexPath = IndexPath(item: throttledIndex, section: 0)
                    self.collectionView.scrollToItem(at: dateSectionIndexPath, at: .centeredHorizontally, animated: true)
                    self.updateFooter()
                }).disposed(by: self.disposeBag)
        }
        
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


