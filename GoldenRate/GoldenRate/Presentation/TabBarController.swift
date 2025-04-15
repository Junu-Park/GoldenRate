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
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = .defaultBackground
        self.tabBar.standardAppearance = tabAppearance
        self.tabBar.scrollEdgeAppearance = tabAppearance

        self.tabBar.layer.shadowColor = UIColor.defaultGray.cgColor
        self.tabBar.layer.shadowOpacity = 0.1
        self.tabBar.unselectedItemTintColor = .defaultGray
        self.tabBar.tintColor = .defaultText
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        
        let homeRepo = RealHomeRepository()
        let homeVM = HomeViewModel(repository: homeRepo)
        let homeVC = HomeViewController(viewModel: homeVM)
        homeVC.navigationItem.backButtonDisplayMode = .minimal
        homeVC.navigationItem.standardAppearance = navigationAppearance
        homeVC.navigationItem.scrollEdgeAppearance = navigationAppearance
        let homeNC = UINavigationController(rootViewController: homeVC)
        let homeTab = UITabBarItem(title: StringConstant.homeTabTitle.localized(), image: .home, tag: 0)
        homeTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        homeNC.tabBarItem = homeTab
        
        let searchRepo = RealSearchRepository()
        let searchVM = SearchViewModel(repository: searchRepo)
        let searchVC = SearchViewController(viewModel: searchVM)
        searchVC.navigationItem.backButtonDisplayMode = .minimal
        searchVC.navigationItem.standardAppearance = navigationAppearance
        searchVC.navigationItem.scrollEdgeAppearance = navigationAppearance
        let searchNC = UINavigationController(rootViewController: searchVC)
        let searchTab = UITabBarItem(title: StringConstant.searchTabTitle.localized(), image: .search, tag: 1)
        searchTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        searchNC.tabBarItem = searchTab
        
        let calculatorVM = CalculatorViewModel()
        let calculatorVC = RenewalCalculatorViewController(viewModel: calculatorVM)
        let calculatorTab = UITabBarItem(title: StringConstant.calculatorTabTitle.localized(), image: .percent, tag: 2)
        calculatorTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        calculatorVC.tabBarItem = calculatorTab
        
        /*
        let moreVC = MoreViewController()
        let moreTab = UITabBarItem(title: StringConstant.moreTabTitle.localized(), image: .more, tag: 3)
        moreTab.setTitleTextAttributes([.font: UIFont.bold10], for: .normal)
        moreVC.tabBarItem = moreTab
        */
        
        self.setViewControllers([homeNC, searchNC, calculatorVC], animated: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
