//
//  RateChartViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import SwiftUI
import UIKit

import SnapKit

final class RateChartViewCell: BaseCollectionViewCell {
    
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()
    private let rateChartViewController: UIHostingController<RateChartView> = UIHostingController(rootView: .init(rateDataList: []))
    
    override func configureHierarchy() {
        self.contentView.addSubviews(self.titleLabel, self.subtitleLabel, self.rateChartViewController.view)
    }
    
    override func configureLayout() {
        self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        self.subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        self.rateChartViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.subtitleLabel.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.contentView.backgroundColor = .defaultBackground
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        
        self.setShadowBorder()
        
        let titleLabelString = NSAttributedString(totalString: "금리 차트", totalColor: .defaultText, totalFont: .bold18, targetString: "금리", targetColor: .accent, targetFont: .bold18)
        self.titleLabel.attributedText = titleLabelString
        
        self.subtitleLabel.text = "예금금리: 정기예금 12개월 기준"
        self.subtitleLabel.font = .regular14
        self.subtitleLabel.textColor = .defaultGray
        
        self.rateChartViewController.view.backgroundColor = .clear
    }
    
    func setView(data: [RateChartEntity]) {
        self.rateChartViewController.rootView = .init(rateDataList: data)
    }
}
