//
//  SearchViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import UIKit

import SnapKit

final class SearchViewCell: BaseCollectionViewCell {
    
    private let symbolImage: UIImageView = UIImageView()
    private let productNameLabel: UILabel = UILabel()
    private let bankNameLabel: UILabel = UILabel()
    private let baseRateLabel: UILabel = UILabel()
    private let maxRateLabel: UILabel = UILabel()
    
    override func configureHierarchy() {
        self.contentView.addSubviews(self.symbolImage, self.productNameLabel, self.bankNameLabel, self.baseRateLabel, self.maxRateLabel)
    }
    
    override func configureLayout() {
        self.symbolImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
            $0.trailing.lessThanOrEqualTo(self.maxRateLabel.snp.leading)
        }

        self.productNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(self.symbolImage.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        }

        self.bankNameLabel.snp.makeConstraints {
            $0.top.equalTo(self.productNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.symbolImage.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        }

        self.baseRateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.baseRateLabel.snp.makeConstraints {
            $0.top.equalTo(self.bankNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.symbolImage.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(self.maxRateLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
        }

        self.maxRateLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    override func configureView() {
        self.setShadowBorder()
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .defaultBackground
        
        self.symbolImage.contentMode = .scaleAspectFit
        
        self.productNameLabel.textColor = .defaultText
        self.productNameLabel.font = .bold18
        
        self.bankNameLabel.textColor = .defaultText
        self.bankNameLabel.font = .regular16
        
        self.baseRateLabel.textColor = .defaultText
        self.baseRateLabel.font = .bold16
        
        self.maxRateLabel.textColor = .accent
        self.maxRateLabel.font = .bold18
    }
    
    func setView(data: DepositProductEntity) {
        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImage.image = UIImage(named: name.trimmingCharacters(in: .whitespaces))
        } else {
            self.symbolImage.image = .저축은행
        }
        
        self.productNameLabel.text = data.name
        
        self.bankNameLabel.text = data.companyName
        
        let minSimpleRate = data.depositSimpleRateList.values.flatMap { $0 }.min() ?? 0
        let minCompoundRate = data.depositCompoundRateList.values.flatMap { $0 }.min() ?? 0
        if min(minSimpleRate, minCompoundRate) == 0 {
            let baseRate = String(format: "%.2f", minCompoundRate == 0 ? minSimpleRate : minCompoundRate)
            self.baseRateLabel.text = "기본금리 \(baseRate)%"
        } else {
            let baseRate = String(format: "%.2f", min(minSimpleRate, minCompoundRate))
            self.baseRateLabel.text = "기본금리 \(baseRate)%"
        }
        
        let maxSimpleRate = data.depositSimpleRateList.values.flatMap { $0 }.max() ?? 0
        let maxCompoundRate = data.depositCompoundRateList.values.flatMap { $0 }.max() ?? 0
        self.maxRateLabel.text = "최고금리 \(String(format: "%.2f", max(maxSimpleRate, maxCompoundRate)))%"
    }
    
    func setView(data: SavingProductEntity) {
        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImage.image = UIImage(named: name.trimmingCharacters(in: .whitespaces))
        } else {
            self.symbolImage.image = .저축은행
        }
        
        self.productNameLabel.text = data.name
        
        self.bankNameLabel.text = data.companyName
        
        let minSimpleRate = data.savingSimpleRateList.values.flatMap { $0 }.min() ?? 0
        let minCompoundRate = data.savingCompoundRateList.values.flatMap { $0 }.min() ?? 0
        if min(minSimpleRate, minCompoundRate) == 0 {
            let baseRate = String(format: "%.2f", minCompoundRate == 0 ? minSimpleRate : minCompoundRate)
            self.baseRateLabel.text = "기본금리 \(baseRate)%"
        } else {
            let baseRate = String(format: "%.2f", min(minSimpleRate, minCompoundRate))
            self.baseRateLabel.text = "기본금리 \(baseRate)%"
        }
        
        let maxSimpleRate = data.savingSimpleRateList.values.flatMap { $0 }.max() ?? 0
        let maxCompoundRate = data.savingCompoundRateList.values.flatMap { $0 }.max() ?? 0
        self.maxRateLabel.text = "최고금리 \(String(format: "%.2f", max(maxSimpleRate, maxCompoundRate)))%"
    }
}
