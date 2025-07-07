//
//  RateChartViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import SwiftUI
import UIKit

final class RateChartViewCell: BaseCollectionViewCell {
    
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    private let rateChartViewController: UIHostingController<RateChartView> = UIHostingController(rootView: .init(rateDataList: []))
    
    override func configureHierarchy() {
        self.contentView.addSubviews(self.titleLabel, self.subtitleLabel, self.rateChartViewController.view)
    }
    
    override func configureLayout() {
        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.titleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: 16)
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: -16)
        }
        
        self.subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.subtitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4)
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: -16)
        }
        
        self.rateChartViewController.view.setConstraints {
            $0.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor)
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor)
        }
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .defaultBackground
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        
        self.setShadowBorder()
        
        let titleLabelString = NSAttributedString(totalString: "금리 차트", totalColor: .defaultText, totalFont: .bold18, targetString: "금리", targetColor: .accent, targetFont: .bold18)
        self.titleLabel.attributedText = titleLabelString
        
        self.subtitleLabel.text = "* 2금융권 예금금리: 정기예금 12개월 기준"
        self.subtitleLabel.font = .regular10
        self.subtitleLabel.textColor = .defaultGray
        
        self.rateChartViewController.view.backgroundColor = .clear
    }
    
    func setView(data: [RateChartEntity]) {
        self.rateChartViewController.rootView = .init(rateDataList: data)
    }
}
