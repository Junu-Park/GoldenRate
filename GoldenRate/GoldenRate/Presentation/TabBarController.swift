//
//  TabBarController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import UIKit

final class TabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.cornerRadius = self.tabBar.frame.height / 2
        self.tabBar.layer.shadowColor = UIColor.defaultGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.2
        self.tabBar.unselectedItemTintColor = .defaultGray
        self.tabBar.tintColor = .defaultText
        self.tabBar.backgroundColor = .defaultBackground
        
        let homeRepo = MockHomeRepository()
        let homeVM = HomeViewModel(repository: homeRepo)
        let homeVC = HomeViewController(viewModel: homeVM)
        let homeTab = UITabBarItem(title: StringConstant.homeTabTitle.localized(), image: .home, tag: 0)
        homeTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        homeVC.tabBarItem = homeTab
        
        let searchVC = SearchViewController()
        let searchTab = UITabBarItem(title: StringConstant.searchTabTitle.localized(), image: .search, tag: 1)
        searchTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        searchVC.tabBarItem = searchTab
        
        let calculatorVC = CalculatorViewController()
        let calculatorTab = UITabBarItem(title: StringConstant.calculatorTabTitle.localized(), image: .percent, tag: 2)
        calculatorTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        calculatorVC.tabBarItem = calculatorTab
        
        let moreVC = MoreViewController()
        let moreTab = UITabBarItem(title: StringConstant.moreTabTitle.localized(), image: .more, tag: 3)
        moreTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        moreVC.tabBarItem = moreTab
        
        self.setViewControllers([homeVC, searchVC, calculatorVC, moreVC], animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
