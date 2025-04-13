//
//  HomeViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import Combine
import SwiftUI
import UIKit

import SnapKit

final class HomeViewController: BaseViewController {

    private lazy var homeCollectionViewDataSource: UICollectionViewDiffableDataSource<HomeCollectionViewSection, HomeCollectionViewItem> = self.configureCollectionViewDataSource()
    private lazy var homeCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCollectionViewLayout())
    
    private let viewModel: HomeViewModel
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(self.homeCollectionView)
    }
    
    override func configureLayout() {
        self.homeCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.homeCollectionView.backgroundColor = .clear
        self.homeCollectionView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        self.homeCollectionView.register(RateChartViewCell.self, forCellWithReuseIdentifier: RateChartViewCell.identifier)
        self.homeCollectionView.register(RateRankingViewCell.self, forCellWithReuseIdentifier: RateRankingViewCell.identifier)
    }
    
    override func bind() {
        let getRateChartData = CurrentValueSubject<Void, Never>(())
        let getDepositProductTopData = CurrentValueSubject<Void, Never>(())
        let getSavingProductTopData = CurrentValueSubject<Void, Never>(())
        
        let input = HomeViewModel.Input(getRateChartData: getRateChartData.eraseToAnyPublisher(), getDepositProductTopData: getDepositProductTopData.eraseToAnyPublisher(), getSavingProductTopData: getSavingProductTopData.eraseToAnyPublisher())
        let output = self.viewModel.transform(input: input)
        
        Publishers.CombineLatest3(
                output.rateChartData,
                output.depositProductTopData,
                output.savingProductTopData
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (chartData, depositProducts, savingProducts) in
                guard let self else {
                    return
                }
                
                self.updateSnapshot(chartData: chartData, depositData: depositProducts, savingData: savingProducts)
            }
            .store(in: &self.cancellables)
    }
}

extension HomeViewController {
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, env in
            
            let itemHeight: NSCollectionLayoutDimension
            let groupHeight: NSCollectionLayoutDimension
            
            if sectionIndex == 0 {
                itemHeight = .fractionalHeight(1)
                groupHeight = .fractionalHeight(0.5)
            } else {
                itemHeight = .estimated(400)
                groupHeight = .estimated(400)
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }, configuration: config)
        return layout
    }
    
    private func configureCollectionViewDataSource() -> UICollectionViewDiffableDataSource<HomeCollectionViewSection, HomeCollectionViewItem> {
        return .init(collectionView: self.homeCollectionView) { collectionView, indexPath, itemType in
            switch itemType {
            case .chart(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateChartViewCell.identifier, for: indexPath) as? RateChartViewCell else {
                    return UICollectionViewCell()
                }
                cell.setView(data: item)
                return cell
            case .ranking(let depositItem, let savingItem):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateRankingViewCell.identifier, for: indexPath) as? RateRankingViewCell else {
                    return UICollectionViewCell()
                }
                cell.setView(depositProducts: depositItem)
                cell.setView(savingsProducts: savingItem)

                return cell
            }
        }
    }
    
    private func updateSnapshot(chartData: [RateChartEntity], depositData: [DepositProductEntity], savingData: [SavingProductEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeCollectionViewSection, HomeCollectionViewItem>()
        
        snapshot.appendSections([.chart, .ranking])
        
        let chartItem = HomeCollectionViewItem.chart(item: chartData)
        let rankingItem = HomeCollectionViewItem.ranking(depositItem: depositData, savingItem: savingData)
        
        snapshot.appendItems([chartItem], toSection: .chart)
        snapshot.appendItems([rankingItem], toSection: .ranking)
        
        self.homeCollectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
}
