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

    private let chartViewController: UIHostingController<RateChartView> = UIHostingController(rootView: .init())
    
    private let viewModel: HomeViewModel
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.addChild(self.chartViewController)
        self.view.addSubview(self.chartViewController.view)
        self.chartViewController.didMove(toParent: self)
    }
    
    override func configureLayout() {
        self.chartViewController.view.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(32)
        }
    }
    
    override func configureView() {
        self.chartViewController.view.backgroundColor = .clear
    }
    
    override func bind() {
        
        let getRateChartData = CurrentValueSubject<Void, Never>(())
        let getDepositProductTopData = CurrentValueSubject<Void, Never>(())
        let getSavingProductTopData = CurrentValueSubject<Void, Never>(())
        
        let input = HomeViewModel.Input(getRateChartData: getRateChartData.eraseToAnyPublisher(), getDepositProductTopData: getDepositProductTopData.eraseToAnyPublisher(), getSavingProductTopData: getSavingProductTopData.eraseToAnyPublisher())
        
        let output = self.viewModel.tranform(input: input)
        
        output.rateChartData
            .sink { [weak self] data in
                self?.chartViewController.rootView = .init(rateDataList: data)
            }
            .store(in: &self.cancellable)
        
        output.depositProductTopData
            .sink { [weak self] data in
                print("-------")
                print(data)
                print("-------")
            }
            .store(in: &self.cancellable)
        
        output.savingProductTopData
            .sink { [weak self] data in
                print("-------")
                print(data)
                print("-------")
            }
            .store(in: &self.cancellable)
    }
}
