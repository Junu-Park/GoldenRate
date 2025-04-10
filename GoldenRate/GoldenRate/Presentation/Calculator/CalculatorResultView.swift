//
//  CalculatorResultView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/10/25.
//

import UIKit

import SnapKit

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
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.principalTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        self.principalValueLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.preTaxInterestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.principalTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        self.preTaxInterestValueLabel.snp.makeConstraints {
            $0.top.equalTo(self.principalValueLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.taxTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.preTaxInterestTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        self.taxValueLabel.snp.makeConstraints {
            $0.top.equalTo(self.preTaxInterestValueLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.afterTaxInterestTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.taxTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        self.afterTaxInterestValueLabel.snp.makeConstraints {
            $0.top.equalTo(self.taxValueLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.totalTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.afterTaxInterestTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        self.totalValueLabel.snp.makeConstraints {
            $0.top.equalTo(self.afterTaxInterestValueLabel.snp.bottom).offset(8)
            $0.trailing.bottom.equalToSuperview().offset(-16)
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
            view.text = "0원"
            view.font = .bold16
            view.textColor = .defaultText
            view.textAlignment = .right
        }
    }
    
    func setView(taxType: TaxType, principal: Int = 0, preTaxInterest: Int = 0, tax: Int = 0, afterTaxInterest: Int = 0, total: Int = 0) {
        self.taxTitleLabel.attributedText = .init(totalString: "이자 세금(\(taxType.percent)%)", totalColor: .defaultGray, totalFont: .thin16, targetString: "이자 세금", targetColor: .defaultGray, targetFont: .regular16)
        self.principalValueLabel.text = "\(principal.formatted())원"
        self.preTaxInterestValueLabel.text = "\(preTaxInterest.formatted())원"
        self.taxValueLabel.text = "\(tax.formatted())원"
        self.afterTaxInterestValueLabel.text = "\(afterTaxInterest.formatted())원"
        self.totalValueLabel.text = "\(total.formatted())원"
    }
}
