//
//  RateRankingViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import UIKit

final class RateRankingViewCell: BaseCollectionViewCell {
    
    private let titleLabel = UILabel()
    private let segmentedControl: CustomSegmentedControl = CustomSegmentedControl(items: [ProductType.deposit, ProductType.saving])
    private let rankingContainerView = UIView()
    private var rankingViews: [RateRankingRowView] = []
    
    private var depositData: [DepositProductEntity] = [] {
        didSet {
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.updateViewWithDepositData()
            }
        }
    }
    private var savingData: [SavingProductEntity] = [] {
        didSet {
            if self.segmentedControl.selectedSegmentIndex == 1 {
                self.updateViewWithSavingData()
            }
        }
    }
    
    override func configureHierarchy() {
        for _ in 0..<3 {
            let rankingView = RateRankingRowView()
            self.rankingViews.append(rankingView)
            self.rankingContainerView.addSubview(rankingView)
        }
        
        self.contentView.addSubviews(self.titleLabel, self.segmentedControl, self.rankingContainerView)
    }
    
    override func configureLayout() {
        self.titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        self.segmentedControl.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        self.rankingContainerView.snp.makeConstraints {
            $0.top.equalTo(self.segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        for (index, view) in rankingViews.enumerated() {
            view.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(16)
                
                if index == 0 {
                    $0.top.equalToSuperview().offset(16)
                } else if index == 1 {
                    $0.top.equalTo(self.rankingViews[index - 1].snp.bottom).offset(16)
                } else {
                    $0.top.equalTo(self.rankingViews[index - 1].snp.bottom).offset(16)
                    $0.bottom.equalToSuperview().offset(-16)
                }
            }
        }
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .defaultBackground
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true

        self.layer.shadowColor = UIColor.defaultText.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero

        let titleLabelString = NSAttributedString(totalString: "예•적금 금리 랭킹 TOP3", totalColor: .defaultText, totalFont: .bold18, targetString: "TOP3", targetColor: .accent, targetFont: .bold18)
        
        self.titleLabel.attributedText = titleLabelString
        
        self.segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            updateViewWithDepositData()
        } else {
            updateViewWithSavingData()
        }
    }
    
    private func updateViewWithDepositData() {
        for (index, product) in self.depositData.enumerated() {
            self.rankingViews[index].setView(rank: index + 1, data: product)
        }
    }
    
    private func updateViewWithSavingData() {
        for (index, product) in self.savingData.enumerated() {
            self.rankingViews[index].setView(rank: index + 1, data: product)
        }
    }
    
    func setView(depositProducts: [DepositProductEntity]) {
        self.depositData = depositProducts
    }
    
    func setView(savingsProducts: [SavingProductEntity]) {
        self.savingData = savingsProducts
    }
}
