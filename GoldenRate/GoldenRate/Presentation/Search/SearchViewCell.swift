//
//  SearchViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import UIKit

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
        self.symbolImage.setConstraints {
            $0.leadingAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.centerYAnchor.constraint(equalTo: $0.superview)
            $0.widthAnchor.constraint(equalToConstant: 50)
            $0.heightAnchor.constraint(equalToConstant: 50)
            $0.trailingAnchor.constraint(lessThanOrEqualTo: self.maxRateLabel.leadingAnchor)
        }

        self.productNameLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.leadingAnchor.constraint(equalTo: self.symbolImage.trailingAnchor, constant: 8)
            $0.trailingAnchor.constraint(lessThanOrEqualTo: $0.superview!.trailingAnchor, constant: -8)
        }

        self.bankNameLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.productNameLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.symbolImage.trailingAnchor, constant: 8)
            $0.trailingAnchor.constraint(lessThanOrEqualTo: $0.superview!.trailingAnchor, constant: -8)
        }

        self.baseRateLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.baseRateLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.bankNameLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.symbolImage.trailingAnchor, constant: 8)
            $0.trailingAnchor.constraint(lessThanOrEqualTo: self.maxRateLabel.leadingAnchor)
            $0.bottomAnchor.constraint(equalTo: $0.superview, constant: -16)
        }

        self.maxRateLabel.setConstraints {
            $0.topAnchor.constraint(greaterThanOrEqualTo: $0.superview!.topAnchor)
            $0.trailingAnchor.constraint(equalTo: $0.superview, constant: -16)
            $0.bottomAnchor.constraint(equalTo: $0.superview, constant: -16)
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
