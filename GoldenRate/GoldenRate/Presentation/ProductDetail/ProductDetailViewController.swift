//
//  ProductDetailViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 4/5/25.
//

import UIKit

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
        self.scrollView.setConstraints {
            $0.horizontalAnchor.constraints(equalTo: $0.superview?.safeAreaLayoutGuide)
            $0.verticalAnchor.constraints(equalTo: $0.superview?.safeAreaLayoutGuide)
        }
        
        self.productDetailView.setConstraints {
            $0.verticalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.widthAnchor.constraint(equalTo: $0.superview!.widthAnchor, constant: -32)
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
