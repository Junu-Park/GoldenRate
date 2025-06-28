//
//  CalculatorResultView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/10/25.
//

import UIKit

final class CalculatorResultView: BaseView {
    
    private let containerView: UIView = UIView()
    
    private let principalTitleLabel = UILabel()
    private let principalValueLabel = UILabel()
    
    private let preTaxInterestTitleLabel = UILabel()
    private let preTaxInterestValueLabel = UILabel()
    
    private let taxTitleLabel = UILabel()
    private let taxValueLabel = UILabel()
    
    private let afterTaxInterestTitleLabel = UILabel()
    private let afterTaxInterestValueLabel = UILabel()
    
    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()
    
    override func configureHierarchy() {
        self.addSubview(self.containerView)
        self.containerView.addSubviews(self.principalTitleLabel, self.principalValueLabel, self.preTaxInterestTitleLabel, self.preTaxInterestValueLabel, self.taxTitleLabel, self.taxValueLabel, self.afterTaxInterestTitleLabel, self.afterTaxInterestValueLabel, self.totalTitleLabel, self.totalValueLabel)
    }
    
    override func configureLayout() {
        self.containerView.setConstraints {
            $0.topAnchor.constraint(equalTo: self.topAnchor)
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        }
        
        self.principalTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        }
        self.principalValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        }
        
        self.preTaxInterestTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.principalTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        }
        self.preTaxInterestValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.principalValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        }
        
        self.taxTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.preTaxInterestTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        }
        self.taxValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.preTaxInterestValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        }
        
        self.afterTaxInterestTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.taxTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        }
        self.afterTaxInterestValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.taxValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        }
        
        self.totalTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.afterTaxInterestTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        }
        self.totalValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.afterTaxInterestValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        }
    }
    
    override func configureView() {
        self.setShadowBorder()
        self.backgroundColor = .clear
        
        self.containerView.clipsToBounds = true
        self.containerView.backgroundColor = .defaultBackground
        self.containerView.layer.cornerRadius = 15
        
        self.principalTitleLabel.text = "원금"
        self.preTaxInterestTitleLabel.text = "세전 이자"
        self.afterTaxInterestTitleLabel.text = "세후 이자"
        self.totalTitleLabel.text = "총 수령 금액"
        
        self.taxTitleLabel.attributedText = .init(totalString: "이자 세금(\(TaxType.general.percent)%)", totalColor: .defaultGray, totalFont: .thin16, targetString: "이자 세금", targetColor: .defaultGray, targetFont: .regular16)
        
        [self.principalTitleLabel, self.preTaxInterestTitleLabel, self.afterTaxInterestTitleLabel, self.totalTitleLabel].forEach { view in
            view.font = .regular16
            view.textColor = .defaultGray
        }
        
        [self.principalValueLabel, self.preTaxInterestValueLabel, self.taxValueLabel, self.afterTaxInterestValueLabel, self.totalValueLabel].forEach { view in
            view.font = .bold16
            view.textColor = .defaultText
            view.textAlignment = .right
        }
        self.totalValueLabel.textColor = .accent
    }
    
    func setView(taxType: TaxType, principal: String, preTaxInterest: String, tax: String, afterTaxInterest: String, total: String) {
        self.taxTitleLabel.attributedText = .init(totalString: "이자 세금(\(taxType.percent)%)", totalColor: .defaultGray, totalFont: .thin16, targetString: "이자 세금", targetColor: .defaultGray, targetFont: .regular16)
        self.principalValueLabel.text = principal
        self.preTaxInterestValueLabel.text = preTaxInterest
        self.taxValueLabel.text = tax
        self.afterTaxInterestValueLabel.text = afterTaxInterest
        self.totalValueLabel.text = total
    }
}
