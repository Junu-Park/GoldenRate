//
//  ProductDetailView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/5/25.
//

import UIKit

import SnapKit

final class ProductDetailView: BaseView {
    
    private let containerView: UIView = UIView()
    private let symbolImage: UIImageView = UIImageView()
    private let productName: UILabel = UILabel()
    private let bankName: UILabel = UILabel()
    private let baseInterestRate: UILabel = UILabel()
    private let HighestInterestRate: UILabel = UILabel()
    private let interestRateMethod: UILabel = UILabel()
    private let maxAmount: UILabel = UILabel()
    private let savingMethod: UILabel = UILabel()
    private let joinTarget: UILabel = UILabel()
    private let joinMethod: UILabel = UILabel()
    private let preferentialCondition: UILabel = UILabel()
    private let periodRatesTitle: UILabel = UILabel()
    private let periodRatesContainer: UIView = UIView()
    private let periodRatesStackView: UIStackView = UIStackView()
    
    override func configureHierarchy() {
        self.addSubview(self.containerView)
        self.containerView.addSubviews(self.symbolImage, self.productName, self.bankName, self.baseInterestRate, self.HighestInterestRate, self.maxAmount, self.savingMethod, self.joinTarget, self.joinMethod, self.preferentialCondition, self.periodRatesTitle, self.periodRatesContainer)
        self.periodRatesContainer.addSubview(self.periodRatesStackView)
    }
    
    override func configureLayout() {
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.symbolImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.size.equalTo(self.snp.width).multipliedBy(0.25)
        }
        self.bankName.snp.makeConstraints {
            $0.top.equalTo(self.symbolImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        self.productName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.productName.snp.makeConstraints {
            $0.top.equalTo(self.bankName.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        self.savingMethod.snp.makeConstraints {
            $0.leading.equalTo(self.productName.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
            $0.bottom.equalTo(self.productName)
        }
        self.HighestInterestRate.snp.makeConstraints {
            $0.top.equalTo(self.productName.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        self.baseInterestRate.snp.makeConstraints {
            $0.top.equalTo(self.productName.snp.bottom).offset(32)
            $0.leading.equalTo(self.containerView.snp.centerX)
        }
        self.joinTarget.snp.makeConstraints {
            $0.top.equalTo(self.HighestInterestRate.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        self.joinMethod.snp.makeConstraints {
            $0.top.equalTo(self.joinTarget.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        self.maxAmount.snp.makeConstraints {
            $0.top.equalTo(self.joinMethod.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        self.periodRatesTitle.snp.makeConstraints {
            $0.top.equalTo(self.maxAmount.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        self.periodRatesContainer.snp.makeConstraints {
            $0.top.equalTo(self.periodRatesTitle.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        self.periodRatesStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.setShadowBorder()
        self.layer.cornerRadius = 15
        
        self.containerView.backgroundColor = .defaultBackground
        self.containerView.layer.cornerRadius = 15
        self.containerView.clipsToBounds = true
        
        self.symbolImage.contentMode = .scaleAspectFit
        
        self.productName.font = .bold20
        self.productName.textColor = .defaultText
        
        self.bankName.font = .bold16
        self.bankName.textColor = .defaultText
        
        [self.HighestInterestRate, self.baseInterestRate, self.interestRateMethod, self.maxAmount, self.savingMethod, self.joinTarget, self.joinMethod, self.preferentialCondition].forEach { view in
            view.numberOfLines = 0
        }
        
        self.periodRatesTitle.font = .bold16
        self.periodRatesTitle.textColor = .defaultGray
        self.periodRatesTitle.text = "가입 개월별 금리"
        
        self.periodRatesStackView.axis = .vertical
        self.periodRatesStackView.spacing = 8
        self.periodRatesStackView.distribution = .fillEqually
        self.periodRatesStackView.alignment = .fill
        
        self.periodRatesContainer.backgroundColor = .clear
    }
    
    func setView(data: DepositProductEntity) {
        
        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImage.image = UIImage(named: name)
        } else {
            self.symbolImage.image = .저축은행
        }
        
        self.productName.text = data.name
        
        self.interestRateMethod.text = data.interestRateType.map { $0.rawValue }.joined(separator: ", ")
        
        self.bankName.text = data.companyName
        
        // 최고 금리 설정
        let maxSimpleRate = data.depositSimpleRateList.values.flatMap { $0 }.max() ?? 0
        
        let maxCompoundRate = data.depositCompoundRateList.values.flatMap { $0 }.max() ?? 0
        
        // 제목 속성 (최고 금리 부분)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,  // 볼드체, 크기는 필요에 맞게 조정
            .foregroundColor: UIColor.defaultGray        // 색상 조정
        ]

        // 값 속성 (숫자 부분)
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold20,  // 더 큰 폰트
            .foregroundColor: UIColor.accent                   // 강조색
        ]

        // 최고 금리 속성 문자열 생성
        let highestRateText = NSMutableAttributedString(string: "최고 금리\n", attributes: titleAttributes)
        let highestRateValue = NSAttributedString(
            string: String(format: "%.2f%%", max(maxSimpleRate, maxCompoundRate)),
            attributes: valueAttributes
        )
        highestRateText.append(highestRateValue)
        self.HighestInterestRate.attributedText = highestRateText

        // 기본 금리 설정
        let minSimpleRate = data.depositSimpleRateList.values.flatMap { $0 }.min() ?? 0
        
        let minCompoundRate = data.depositCompoundRateList.values.flatMap { $0 }.min() ?? 0
        
        let minRate: String
        
        if min(minSimpleRate, minCompoundRate) == 0 {
            minRate = String(format: "%.2f%%", minCompoundRate == 0 ? minSimpleRate : minCompoundRate)
        } else {
            minRate = String(format: "%.2f%%", max(minSimpleRate, minCompoundRate))
        }

        // 기본 금리 속성 문자열 생성
        let baseRateText = NSMutableAttributedString(string: "기본 금리\n", attributes: titleAttributes)
        let valueAttributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold20,  // 더 큰 폰트
            .foregroundColor: UIColor.defaultText                   // 강조색
        ]
        let baseRateValue = NSAttributedString(
            string: minRate,
            attributes: valueAttributes2
        )
        baseRateText.append(baseRateValue)
        self.baseInterestRate.attributedText = baseRateText
        
        // 제목 스타일 속성 정의
        let titleAttributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,  // 볼드체, 크기는 필요에 맞게 조정
            .foregroundColor: UIColor.defaultGray       // 파란색 또는 원하는 색상
        ]

        // 내용 스타일 속성 정의
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,      // 일반 폰트
            .foregroundColor: UIColor.defaultText         // 어두운 회색 또는 원하는 색상
        ]

        // 가입 한도
        let maxAmountText = NSMutableAttributedString(string: "가입 한도 금액\n", attributes: titleAttributes2)
        let maxAmountValue = NSAttributedString(
            string: "\(data.maxLimit == 0 ? "없음" : (data.maxLimit.formatted() + "원"))",
            attributes: contentAttributes
        )
        maxAmountText.append(maxAmountValue)
        self.maxAmount.attributedText = maxAmountText

        // 가입 대상
        let joinTargetText = NSMutableAttributedString(string: "가입 대상\n", attributes: titleAttributes2)
        let joinTargetValue = NSAttributedString(string: "\(data.joinTarget)", attributes: contentAttributes)
        joinTargetText.append(joinTargetValue)
        self.joinTarget.attributedText = joinTargetText

        // 가입 방법
        let joinMethodText = NSMutableAttributedString(string: "가입 방법\n", attributes: titleAttributes2)
        let joinMethodValue = NSAttributedString(
            string: "\(data.joinWay.joined(separator: ", "))",
            attributes: contentAttributes
        )
        joinMethodText.append(joinMethodValue)
        self.joinMethod.attributedText = joinMethodText
        
        // 가입 개월별 금리 정보 타이틀 설정
        self.periodRatesTitle.text = "가입 개월별 금리"
        
        // 가입 개월별 금리 표시
        configurePeriodicRates(depositSimpleRates: data.depositSimpleRateList, depositCompoundRates: data.depositCompoundRateList)
    }
    
    func setView(data: SavingProductEntity) {

        if let name = FirstBankType.init(rawValue: data.companyID)?.name {
            self.symbolImage.image = UIImage(named: name)
        } else {
            self.symbolImage.image = .저축은행
        }
        
        self.productName.text = data.name
        
        self.savingMethod.font = .bold16
        self.savingMethod.textColor = .defaultGray
        self.savingMethod.text = "(\(data.savingMethod))"
        
        self.interestRateMethod.text = data.interestRateType.map { $0.rawValue }.joined(separator: ", ")
        
        self.bankName.text = data.companyName
        
        // 최고 금리 설정
        let maxSimpleRate = data.savingSimpleRateList.values.flatMap { $0 }.max() ?? 0
        
        let maxCompoundRate = data.savingCompoundRateList.values.flatMap { $0 }.max() ?? 0
        
        // 제목 속성 (최고 금리 부분)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,  // 볼드체, 크기는 필요에 맞게 조정
            .foregroundColor: UIColor.defaultGray        // 색상 조정
        ]

        // 값 속성 (숫자 부분)
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold20,  // 더 큰 폰트
            .foregroundColor: UIColor.accent                   // 강조색
        ]

        // 최고 금리 속성 문자열 생성
        let highestRateText = NSMutableAttributedString(string: "최고 금리\n", attributes: titleAttributes)
        let highestRateValue = NSAttributedString(
            string: String(format: "%.2f%%", max(maxSimpleRate, maxCompoundRate)),
            attributes: valueAttributes
        )
        highestRateText.append(highestRateValue)
        self.HighestInterestRate.attributedText = highestRateText

        // 기본 금리 설정
        let minSimpleRate = data.savingSimpleRateList.values.flatMap { $0 }.min() ?? 0
        
        let minCompoundRate = data.savingCompoundRateList.values.flatMap { $0 }.min() ?? 0
        
        let minRate: String
        
        if min(minSimpleRate, minCompoundRate) == 0 {
            minRate = String(format: "%.2f%%", minCompoundRate == 0 ? minSimpleRate : minCompoundRate)
        } else {
            minRate = String(format: "%.2f%%", max(minSimpleRate, minCompoundRate))
        }

        // 기본 금리 속성 문자열 생성
        let baseRateText = NSMutableAttributedString(string: "기본 금리\n", attributes: titleAttributes)
        let valueAttributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold20,  // 더 큰 폰트
            .foregroundColor: UIColor.defaultText                   // 강조색
        ]
        let baseRateValue = NSAttributedString(
            string: minRate,
            attributes: valueAttributes2
        )
        baseRateText.append(baseRateValue)
        self.baseInterestRate.attributedText = baseRateText
        
        // 제목 스타일 속성 정의
        let titleAttributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,  // 볼드체, 크기는 필요에 맞게 조정
            .foregroundColor: UIColor.defaultGray       // 파란색 또는 원하는 색상
        ]

        // 내용 스타일 속성 정의
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bold16,      // 일반 폰트
            .foregroundColor: UIColor.defaultText         // 어두운 회색 또는 원하는 색상
        ]

        // 가입 한도
        let maxAmountText = NSMutableAttributedString(string: "월 납입 한도\n", attributes: titleAttributes2)
        let maxAmountValue = NSAttributedString(
            string: "\(data.maxLimit == 0 ? "없음" : (data.maxLimit.formatted() + "원"))",
            attributes: contentAttributes
        )
        maxAmountText.append(maxAmountValue)
        self.maxAmount.attributedText = maxAmountText

        // 가입 대상
        let joinTargetText = NSMutableAttributedString(string: "가입 대상\n", attributes: titleAttributes2)
        let joinTargetValue = NSAttributedString(string: "\(data.joinTarget)", attributes: contentAttributes)
        joinTargetText.append(joinTargetValue)
        self.joinTarget.attributedText = joinTargetText

        // 가입 방법
        let joinMethodText = NSMutableAttributedString(string: "가입 방법\n", attributes: titleAttributes2)
        let joinMethodValue = NSAttributedString(
            string: "\(data.joinWay.joined(separator: ", "))",
            attributes: contentAttributes
        )
        joinMethodText.append(joinMethodValue)
        self.joinMethod.attributedText = joinMethodText
        
        // 가입 개월별 금리 정보 타이틀 설정
        self.periodRatesTitle.text = "가입 개월별 금리"
        
        // 가입 개월별 금리 표시
        configurePeriodicRates(savingSimpleRates: data.savingSimpleRateList, savingCompoundRates: data.savingCompoundRateList)
    }
    
    // 적금 상품의 가입 개월별 금리 표시
    private func configurePeriodicRates(savingSimpleRates: [Int: [Double]], savingCompoundRates: [Int: [Double]]) {
        configurePeriodicRatesInternal(simpleRates: savingSimpleRates, compoundRates: savingCompoundRates)
    }
    
    // 예금 상품의 가입 개월별 금리 표시
    private func configurePeriodicRates(depositSimpleRates: [Int: [Double]], depositCompoundRates: [Int: [Double]]) {
        configurePeriodicRatesInternal(simpleRates: depositSimpleRates, compoundRates: depositCompoundRates)
    }
    
    // 상품의 가입 개월별 금리 표시 내부 구현
    private func configurePeriodicRatesInternal(simpleRates: [Int: [Double]], compoundRates: [Int: [Double]]) {
        // 기존 스택뷰의 서브뷰 제거
        self.periodRatesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 모든 기간 키 추출 및 정렬
        var allPeriods = Set<Int>()
        simpleRates.keys.forEach { allPeriods.insert($0) }
        compoundRates.keys.forEach { allPeriods.insert($0) }
        let periods = Array(allPeriods).sorted()
        
        for period in periods {
            let simpleRatesForPeriod = simpleRates[period] ?? []
            let compoundRatesForPeriod = compoundRates[period] ?? []
            
            // 두 리스트를 합쳐서 최저/최고 금리 계산
            let allRates = simpleRatesForPeriod + compoundRatesForPeriod
            if allRates.isEmpty { continue }
            
            let minRate = allRates.min() ?? 0
            let maxRate = allRates.max() ?? 0
            
            // 금리 타입 정보 구성
            var rateTypes: [String] = []
            if !simpleRatesForPeriod.isEmpty {
                rateTypes.append("단리")
            }
            if !compoundRatesForPeriod.isEmpty {
                rateTypes.append("복리")
            }
            let rateTypeString = rateTypes.joined(separator: ", ")
            
            let rateView = createPeriodRateView(
                period: period,
                minRate: minRate,
                maxRate: maxRate,
                rateType: rateTypeString
            )
            self.periodRatesStackView.addArrangedSubview(rateView)
        }
    }
    
    // 개월별 금리 표시 뷰 생성 함수
    private func createPeriodRateView(period: Int, minRate: Double, maxRate: Double, rateType: String = "") -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.defaultBackground.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 8
        
        let periodLabel = UILabel()
        periodLabel.font = .bold16
        periodLabel.textColor = .defaultText
        periodLabel.text = "\(period)개월"
        
        let rateTypeLabel = UILabel()
        rateTypeLabel.font = .regular14
        rateTypeLabel.textColor = .defaultGray
        rateTypeLabel.text = rateType
        
        let minRateLabel = UILabel()
        minRateLabel.font = .bold16
        minRateLabel.textColor = .defaultText
        minRateLabel.text = String(format: "기본 %.2f%%", minRate)
        
        let maxRateLabel = UILabel()
        maxRateLabel.font = .bold20
        maxRateLabel.textColor = .accent
        maxRateLabel.text = String(format: "최대 %.2f%%", maxRate)
        
        containerView.addSubviews(periodLabel, rateTypeLabel, minRateLabel, maxRateLabel)
        
        periodLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(60)
        }
        
        // 금리 타입이 존재하는 경우에만 표시
        if !rateType.isEmpty {
            rateTypeLabel.snp.makeConstraints {
                $0.top.equalTo(periodLabel.snp.bottom).offset(4)
                $0.leading.equalTo(periodLabel)
                $0.bottom.equalToSuperview().offset(-12)
            }
        } else {
            periodLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-12)
            }
        }
        
        minRateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(periodLabel.snp.trailing).offset(16)
        }
        
        maxRateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(minRateLabel.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        return containerView
    }
}
