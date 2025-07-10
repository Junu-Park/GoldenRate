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
        self.titleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.leadingAnchor.constraint(equalTo: $0.superview, constant: 16)
        }
        
        self.segmentedControl.setConstraints {
            $0.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 32)
        }
        
        self.rankingContainerView.setConstraints {
            $0.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor)
            $0.horizontalAnchor.constraints(equalTo: $0.superview)
            $0.bottomAnchor.constraint(equalTo: $0.superview)
        }
        
        for (index, view) in rankingViews.enumerated() {
            view.setConstraints {
                $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
                if index == 0 {
                    $0.topAnchor.constraint(equalTo: $0.superview, constant: 16)
                } else if index == 1 {
                    $0.topAnchor.constraint(equalTo: self.rankingViews[index - 1].bottomAnchor, constant: 16)
                } else {
                    $0.topAnchor.constraint(equalTo: self.rankingViews[index - 1].bottomAnchor, constant: 16)
                    $0.bottomAnchor.constraint(equalTo: $0.superview, constant: -16)
                }
            }
        }
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .defaultBackground
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true

        self.setShadowBorder()

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
