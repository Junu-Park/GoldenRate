//
//  RateRankingRowView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import UIKit

import SnapKit

final class RateRankingRowView: BaseView {
    
    private let rankLabel: UILabel = UILabel()
    private let symbolImageView: UIImageView = UIImageView()
    private let nameStackView: UIStackView = UIStackView()
    private let productNameLabel: UILabel = UILabel()
    private let bankNameLabel: UILabel = UILabel()
    private let rateLabel: UILabel = UILabel()
    
    override func configureHierarchy() {
        self.nameStackView.addArrangedSubview(self.productNameLabel)
        self.nameStackView.addArrangedSubview(self.bankNameLabel)
        self.addSubviews(self.rankLabel, self.symbolImageView, self.nameStackView, self.rateLabel)
    }
    
    override func configureLayout() {
        self.nameStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        self.rankLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        self.symbolImageView.snp.makeConstraints {
            $0.leading.equalTo(self.rankLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(25)
        }
        self.nameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalTo(self.symbolImageView.snp.trailing).offset(8)
        }
        self.rateLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(self.nameStackView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    override func configureView() {
        self.layer.cornerRadius = 10
        self.setShadowBorder()
        
        self.rankLabel.font = .bold14
        self.rankLabel.textColor = .text
        
        self.symbolImageView.clipsToBounds = true
        self.symbolImageView.layer.cornerRadius = 25 / 2
        self.symbolImageView.contentMode = .scaleAspectFit
        
        self.nameStackView.axis = .vertical
        self.nameStackView.alignment = .leading
        self.nameStackView.distribution = .fillEqually
        
        self.productNameLabel.font = .bold14
        self.productNameLabel.textColor = .text
        
        self.bankNameLabel.font = .regular10
        self.bankNameLabel.textColor = .text
        
        self.rateLabel.font = .bold16
        self.rateLabel.textColor = .text
    }
    
    func setView(rank: Int, data: DepositProductEntity) {
        self.rankLabel.text = String(rank)
        
        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImageView.image = UIImage(named: name)
        } else {
            self.symbolImageView.image = .저축은행
        }
        
        self.productNameLabel.text = data.name
        
        self.bankNameLabel.text = data.companyName
        
        let maxSimpleRate = data.depositSimpleRateList[12]?.max() ?? 0
        let maxCompoundRate = data.depositCompoundRateList[12]?.max() ?? 0
        self.rateLabel.text = String(format: "%.2f", max(maxSimpleRate, maxCompoundRate)) + "%"
    }
    
    func setView(rank: Int, data: SavingProductEntity) {
        self.rankLabel.text = String(rank)
        
        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImageView.image = UIImage(named: name)
        } else {
            self.symbolImageView.image = .저축은행
        }
        
        self.productNameLabel.text = data.name
        
        self.bankNameLabel.text = data.companyName
        
        let maxSimpleRate = data.savingSimpleRateList[12]?.max() ?? 0
        let maxCompoundRate = data.savingCompoundRateList[12]?.max() ?? 0
        self.rateLabel.text = String(format: "%.2f", max(maxSimpleRate, maxCompoundRate)) + "%"
    }
}
