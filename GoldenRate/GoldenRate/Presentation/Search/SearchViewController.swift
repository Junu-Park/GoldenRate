//
//  SearchViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import Combine
import UIKit

final class SearchViewController: BaseViewController {

    private let searchBar: UISearchBar = UISearchBar()
    private let segmentedControl: CustomSegmentedControl = CustomSegmentedControl<ProductType>(items: ProductType.allCases)
    private let filterSummaryLabel: UILabel = UILabel()
    private let filterButton: UIButton = UIButton()
    private lazy var searchCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCollectionViewLayout())
    private lazy var searchCollectionViewDataSource: UICollectionViewDiffableDataSource<SearchCollectionViewSection, SearchCollectionViewItem> = self.configureCollectionViewDataSource()
    
    @Published private var filterData: SearchFilter = SearchFilter() {
        didSet {
            self.filterSummaryLabel.text = self.filterData.summaryString
        }
    }
    private let viewModel: SearchViewModel
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews(self.searchBar, self.segmentedControl, self.filterSummaryLabel, self.filterButton, self.searchCollectionView)
    }
    
    override func configureLayout() {
        
        self.searchBar.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview?.safeAreaLayoutGuide)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
        }
        
        self.segmentedControl.setConstraints {
            $0.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 8)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        
        self.filterSummaryLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        
        self.filterButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.filterButton.setConstraints {
            $0.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.filterSummaryLabel.trailingAnchor)
            $0.trailingAnchor.constraint(equalTo: $0.superview, constant: -16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        
        self.searchCollectionView.setConstraints {
            $0.topAnchor.constraint(equalTo: self.filterButton.bottomAnchor, constant: 8)
            $0.horizontalAnchor.constraints(equalTo: $0.superview)
            $0.bottomAnchor.constraint(equalTo: $0.superview)
        }
    }
    
    override func configureView() {
        self.searchCollectionView.delegate = self
        self.searchCollectionView.keyboardDismissMode = .onDrag
        
        self.searchBar.setShadowBorder()
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.tintColor = .defaultText
        self.searchBar.backgroundColor = .defaultBackground
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.searchTextField.textColor = .defaultText
        self.searchBar.searchTextField.backgroundColor = .defaultBackground
        self.searchBar.searchTextField.leftView?.tintColor = .defaultText
        self.searchBar.searchTextField.font = .regular16
        self.searchBar.searchTextField.attributedPlaceholder = .init(string: "상품명 또는 은행명 검색", attributes: [.foregroundColor: UIColor.defaultGray, .font: UIFont.regular16])
        self.searchBar.delegate = self
        
        self.segmentedControl.addTarget(self, action: #selector(self.segmentValueChanged), for: .valueChanged)
        
        self.filterSummaryLabel.font = .regular14
        self.filterSummaryLabel.textColor = .text
        self.filterSummaryLabel.text = self.filterData.summaryString
        
        self.filterButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        self.filterButton.tintColor = .accent
        self.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        self.searchCollectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.identifier)
        self.searchCollectionView.register(SearchViewCellSkeleton.self, forCellWithReuseIdentifier: SearchViewCellSkeleton.identifier)
        self.searchCollectionView.backgroundColor = .clear
    }
    
    override func bind() {
        let getProductData = PassthroughSubject<(SearchFilter, ProductType), Never>()
        
        self.$filterData
            .map { [weak self] filter in
                guard let self else {
                    return (filter, ProductType.deposit)
                }
                
                self.updateSnapshotSkeleton()
                
                let productType: ProductType = self.segmentedControl.selectedSegmentIndex == 0 ? .deposit : .saving
                
                return (filter, productType)
            }
            .sink { value in
                getProductData.send(value)
            }
            .store(in: &self.cancellables)
        
        let input = SearchViewModel.Input(initProductData: Just(()).eraseToAnyPublisher(), getProductData: getProductData.eraseToAnyPublisher())
        let output = self.viewModel.transform(input: input)
        
        output.depositProductData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataArray in
                guard let self else {
                    return
                }

                self.updateSnapshot(productType: .deposit, data: dataArray)
            }
            .store(in: &self.cancellables)
        
        output.savingProductData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dataArray in
                guard let self else {
                    return
                }
                
                self.updateSnapshot(productType: .saving, data: dataArray)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateSnapshot<T: Hashable>(productType: ProductType, data: [T]) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchCollectionViewSection, SearchCollectionViewItem>()
        snapshot.appendSections([.main])
        
        switch productType {
        case .deposit:
            guard let item = data as? [DepositProductEntity] else {
                return
            }
            
            snapshot.appendItems(item.map { SearchCollectionViewItem.deposit(item: $0) }, toSection: .main)
        case .saving:
            guard let item = data as? [SavingProductEntity] else {
                return
            }
            
            snapshot.appendItems(item.map { SearchCollectionViewItem.saving(item: $0) }, toSection: .main)
        }
        
        self.searchCollectionViewDataSource.apply(snapshot, animatingDifferences: true)
        
        self.searchCollectionView.setContentOffset(.zero, animated: true)
    }
    
    private func updateSnapshotSkeleton() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchCollectionViewSection, SearchCollectionViewItem>()
        snapshot.appendSections([.main])
        
        let skeletonItems = (0..<6).map { _ in SearchCollectionViewItem.skeleton(id: UUID()) }
        
        snapshot.appendItems(skeletonItems, toSection: .main)
        
        self.searchCollectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        self.filterData.productType = sender.selectedSegmentIndex == 0 ? .deposit : .saving
    }
    
    @objc private func filterButtonTapped() {
        let vc = SearchFilterViewController(filter: self.filterData)
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium(), .large()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        vc.applyClosure = { [weak self] filter in
            guard let self else {
                return
            }
            self.filterData = filter
        }
        self.present(vc, animated: true)
    }
}

extension SearchViewController {
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .background
        config.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 16
            
            return section
        }
        
        return layout
    }
    
    func configureCollectionViewDataSource() -> UICollectionViewDiffableDataSource<SearchCollectionViewSection, SearchCollectionViewItem> {
        return UICollectionViewDiffableDataSource<SearchCollectionViewSection, SearchCollectionViewItem>(collectionView: self.searchCollectionView) { collectionView, indexPath, item in
            
            switch item {
            case .deposit(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else {
                    return UICollectionViewCell()
                }
                cell.setView(data: item)
                
                return cell
            case .saving(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.identifier, for: indexPath) as? SearchViewCell else {
                    return UICollectionViewCell()
                }
                cell.setView(data: item)
                
                return cell
            case .skeleton:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCellSkeleton.identifier, for: indexPath) as? SearchViewCellSkeleton else {
                    return UICollectionViewCell()
                }
                
                return cell
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterData.searchText = searchText
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.searchCollectionViewDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .deposit(let item):
            self.navigationController?.pushViewController(ProductDetailViewController(data: item), animated: true)
        case .saving(let item):
            self.navigationController?.pushViewController(ProductDetailViewController(data: item), animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? SearchViewCellSkeleton {
            cell.start()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? SearchViewCellSkeleton {
            cell.stop()
        }
    }
}
