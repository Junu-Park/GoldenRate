//
//  ProductDetailViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 4/5/25.
//

import UIKit

import SnapKit

final class ProductDetailViewController: BaseViewController {

    private let scrollView: UIScrollView = UIScrollView()
    private let productDetailView: ProductDetailView = ProductDetailView()
    
    init(data: DepositProductEntity) {
        super.init()
        self.productDetailView.setView(data: data)
    }
    
    init(data: SavingProductEntity) {
        super.init()
        self.productDetailView.setView(data: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.productDetailView)
    }
    
    override func configureLayout() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.productDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalToSuperview().offset(-32)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .background
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = navigationAppearance
        self.navigationItem.scrollEdgeAppearance = navigationAppearance
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.alwaysBounceVertical = true
    }
}
