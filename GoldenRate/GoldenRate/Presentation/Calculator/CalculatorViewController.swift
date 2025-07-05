//
//  CalculatorViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/27/25.
//

import UIKit

final class CalculatorViewController: BaseViewController {
    
    private let calculatorTypeSegment = CustomSegmentedControl<ProductType>(
        items: ProductType.allCases
    )
    
    private let amountTitleLabel = UILabel()
    private let amountTextField = UITextField()
    private let amountUnitLabel = UILabel()
    
    private let rateTitleLabel = UILabel()
    private let rateTextField = UITextField()
    private let rateUnitLabel = UILabel()
    
    private let periodTitleLabel = UILabel()
    private let periodTextField = UITextField()
    private let periodUnitSegment = CustomSegmentedControl<PeriodType>(
        items: PeriodType.allCases
    )
    
    private let taxTitleLabel = UILabel()
    private let taxTypeSegment = CustomSegmentedControl<TaxType>(
        items: TaxType.allCases,
        isDynamicSize: true
    )
    
    private let resultContainerView = UIView()
    private let principalTitleLabel = UILabel()
    private let principalValueLabel = UILabel()
    
    private let preInterestTitleLabel = UILabel()
    private let preInterestValueLabel = UILabel()
    
    private let taxTitleLabel2 = UILabel()
    private let taxRateLabel = UILabel()
    private let taxValueLabel = UILabel()
    
    private let postInterestTitleLabel = UILabel()
    private let postInterestValueLabel = UILabel()
    
    private let totalTitleLabel = UILabel()
    private let totalValueLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
    }
    
    
    override func configureHierarchy() {
        self.view.addSubviews(self.calculatorTypeSegment, self.periodUnitSegment, self.taxTitleLabel, self.taxTypeSegment, self.resultContainerView)
    }
    
    override func configureView() {
        
        // 입력 필드 설정
        setupInputField(title: amountTitleLabel, textField: amountTextField, unit: amountUnitLabel, titleText: "예치 금액", unitText: "원")
        setupInputField(title: rateTitleLabel, textField: rateTextField, unit: rateUnitLabel, titleText: "연 이율", unitText: "%")
        setupInputField(title: periodTitleLabel, textField: periodTextField, unit: nil, titleText: "예치 기간", unitText: "")
        
        taxTitleLabel.text = "이자 세율"
        taxTitleLabel.font = .regular16
        taxTitleLabel.textColor = .text
        
        self.periodUnitSegment.backgroundColor = .defaultBackground
        
        self.taxTypeSegment.backgroundColor = .defaultBackground
        
        // 결과 컨테이너 설정
        resultContainerView.backgroundColor = .defaultBackground
        resultContainerView.layer.cornerRadius = 15
        resultContainerView.setShadowBorder()
        
        // 결과 필드 설정
        setupResultField(title: principalTitleLabel, value: principalValueLabel, titleText: "원금")
        setupResultField(title: preInterestTitleLabel, value: preInterestValueLabel, titleText: "세전 이자")
        setupTaxResultField()
        setupResultField(title: postInterestTitleLabel, value: postInterestValueLabel, titleText: "세후 이자")
        setupResultField(title: totalTitleLabel, value: totalValueLabel, titleText: "총 수령 금액")
        
        // 숫자 키패드 설정
        amountTextField.keyboardType = .numberPad
        rateTextField.keyboardType = .decimalPad
        periodTextField.keyboardType = .numberPad
        
        amountTextField.tag = 1
        rateTextField.tag = 2
        periodTextField.tag = 3
    }
    
    private func setupInputField(title: UILabel, textField: UITextField, unit: UILabel?, titleText: String, unitText: String) {
        title.text = titleText
        title.font = .regular16
        title.textColor = .text
        view.addSubview(title)
        
        textField.borderStyle = .roundedRect
        textField.textAlignment = .right
        textField.backgroundColor = .defaultBackground
        textField.textColor = .defaultText
        textField.tintColor = .defaultText
        view.addSubview(textField)
        
        if let unit = unit {
            unit.text = unitText
            unit.font = .regular14
            unit.textColor = .defaultGray
            view.addSubview(unit)
        }
    }
    
    private func setupResultField(title: UILabel, value: UILabel, titleText: String) {
        title.text = titleText
        title.font = .regular16
        title.textColor = .defaultGray
        resultContainerView.addSubview(title)
        
        value.text = "0"
        value.font = .bold16
        value.textAlignment = .right
        value.textColor = .defaultText
        resultContainerView.addSubview(value)
    }
    
    private func setupTaxResultField() {
        taxTitleLabel2.text = "이자 세금"
        taxTitleLabel2.font = .regular16
        taxTitleLabel2.textColor = .defaultGray
        resultContainerView.addSubview(taxTitleLabel2)
        
        taxRateLabel.text = "(15.4%)"
        taxRateLabel.font = .regular10
        taxRateLabel.textColor = .defaultGray
        resultContainerView.addSubview(taxRateLabel)
        
        taxValueLabel.text = "0"
        taxValueLabel.font = .bold16
        taxValueLabel.textAlignment = .right
        taxValueLabel.textColor = .defaultText
        resultContainerView.addSubview(taxValueLabel)
    }
    
    private func setupActions() {
        
        // 실시간 계산을 위한 액션 추가
        calculatorTypeSegment.addTarget(self, action: #selector(inputChanged), for: .valueChanged)
        taxTypeSegment.addTarget(self, action: #selector(inputChanged), for: .valueChanged)
        periodUnitSegment.addTarget(self, action: #selector(inputChanged), for: .valueChanged)
        
        // 텍스트 필드 델리게이트 설정
        amountTextField.delegate = self
        rateTextField.delegate = self
        periodTextField.delegate = self
        
        // 텍스트 필드 편집 종료 이벤트
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        rateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        periodTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // 배경 탭 시 키보드 내리기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        
        self.calculatorTypeSegment.setConstraints {
            $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        
        self.amountTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.calculatorTypeSegment.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        }
        self.amountTextField.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.amountTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.amountTitleLabel.trailingAnchor, constant: 16)
        }
        self.amountUnitLabel.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.amountTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.amountTextField.trailingAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        }
        
        self.rateTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.amountTitleLabel.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        }
        self.rateTextField.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.rateTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.rateTitleLabel.trailingAnchor, constant: 16)
        }
        self.rateUnitLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.rateUnitLabel.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.rateTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.rateTextField.trailingAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        }
        
        self.periodTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.rateTitleLabel.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        }
        self.periodTextField.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.periodTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.periodTitleLabel.trailingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        }
        self.periodUnitSegment.setConstraints {
            $0.topAnchor.constraint(equalTo: self.periodTextField.bottomAnchor, constant: 4)
            $0.leadingAnchor.constraint(equalTo: self.periodTitleLabel.trailingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            $0.heightAnchor.constraint(equalToConstant: 32)
        }
        self.taxTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.periodUnitSegment.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2)
        }
        self.taxTypeSegment.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.taxTitleLabel.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.taxTitleLabel.trailingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            $0.heightAnchor.constraint(equalToConstant: 32)
        }

        self.resultContainerView.setConstraints {
            $0.topAnchor.constraint(equalTo: self.taxTypeSegment.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
            $0.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        }
        
        self.principalTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.resultContainerView.topAnchor, constant: 16)
            $0.leadingAnchor.constraint(equalTo: self.resultContainerView.leadingAnchor, constant: 16)
        }
        self.principalValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.resultContainerView.topAnchor, constant: 16)
            $0.trailingAnchor.constraint(equalTo: self.resultContainerView.trailingAnchor, constant: -16)
        }
        
        self.preInterestTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.principalTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.resultContainerView.leadingAnchor, constant: 16)
        }
        self.preInterestValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.principalValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.resultContainerView.trailingAnchor, constant: -16)
        }
        
        self.taxTitleLabel2.setConstraints {
            $0.topAnchor.constraint(equalTo: self.preInterestTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.resultContainerView.leadingAnchor, constant: 16)
        }

        self.taxRateLabel.setConstraints {
            $0.centerYAnchor.constraint(equalTo: self.taxTitleLabel2.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: self.taxTitleLabel2.trailingAnchor, constant: 4)
        }
        self.taxValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.preInterestValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.resultContainerView.trailingAnchor, constant: -16)
        }
        
        self.postInterestTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.taxTitleLabel2.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.resultContainerView.leadingAnchor, constant: 16)
        }
        self.postInterestValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.taxValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.resultContainerView.trailingAnchor, constant: -16)
        }
        
        self.totalTitleLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.postInterestTitleLabel.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.resultContainerView.leadingAnchor, constant: 16)
            $0.bottomAnchor.constraint(equalTo: self.resultContainerView.bottomAnchor, constant: -16)
        }
        self.totalValueLabel.setConstraints {
            $0.topAnchor.constraint(equalTo: self.postInterestValueLabel.bottomAnchor, constant: 8)
            $0.trailingAnchor.constraint(equalTo: self.resultContainerView.trailingAnchor, constant: -16)
            $0.bottomAnchor.constraint(equalTo: self.resultContainerView.bottomAnchor, constant: -16)
        }
    }
    
    // MARK: - 이벤트 핸들러
    @objc private func calculatorTypeChanged() {
        let productType = ProductType.allCases[calculatorTypeSegment.selectedSegmentIndex]
        amountTitleLabel.text = productType == .deposit ? "예치 금액" : "월 납입액"
        // UI 업데이트 및 계산 초기화
        resetCalculation()
    }
    
    @objc private func taxTypeChanged() {
        let selectedTaxType = TaxType.allCases[taxTypeSegment.selectedSegmentIndex]
        let taxRatePercentage = selectedTaxType.percent
        taxRateLabel.text = "(\(taxRatePercentage)%)"
    }
    
    @objc private func inputChanged() {
        calculatorTypeChanged()
        // 세율 정보 업데이트
        taxTypeChanged()
        
        // 입력값 확인 후 계산 실행
        calculateIfPossible()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // 입력값 확인 후 계산 실행
        calculateIfPossible()
    }
    
    private func calculateIfPossible() {
        // 모든 필수 필드가 입력되었는지 확인
        guard let amountText = amountTextField.text, !amountText.isEmpty,
              let rateText = rateTextField.text, !rateText.isEmpty,
              let periodText = periodTextField.text, !periodText.isEmpty,
              let amount = Double(amountText.replacingOccurrences(of: ",", with: "")),
              let rate = Double(rateText),
              let period = Int(periodText) else {
            return
        }
        
        let selectedTaxType = TaxType.allCases[taxTypeSegment.selectedSegmentIndex]
        let taxRate = selectedTaxType.percent / 100
        let periodUnit = PeriodType.allCases[periodUnitSegment.selectedSegmentIndex]
        
        let productType = ProductType.allCases[calculatorTypeSegment.selectedSegmentIndex]
        if productType == .deposit {
            // 정기예금 계산
            calculateDeposit(amount: amount, rate: rate, period: period, periodUnit: periodUnit, taxRate: taxRate)
        } else {
            // 적금 계산
            calculateInstallment(amount: amount, rate: rate, period: period, periodUnit: periodUnit, taxRate: taxRate)
        }
    }
    
    @objc private func calculateButtonTapped() {
        dismissKeyboard()
        
        guard let amountText = amountTextField.text, !amountText.isEmpty,
              let rateText = rateTextField.text, !rateText.isEmpty,
              let periodText = periodTextField.text, !periodText.isEmpty,
              let amount = Double(amountText.replacingOccurrences(of: ",", with: "")),
              let rate = Double(rateText),
              let period = Int(periodText) else {
            showAlert(message: "모든 필드를 올바르게 입력해주세요.")
            return
        }
        
        let selectedTaxType = TaxType.allCases[taxTypeSegment.selectedSegmentIndex]
        let taxRate = selectedTaxType.percent / 100
        let periodUnit = PeriodType.allCases[periodUnitSegment.selectedSegmentIndex]
        
        let productType = ProductType.allCases[calculatorTypeSegment.selectedSegmentIndex]
        if productType == .deposit {
            // 정기예금 계산
            calculateDeposit(amount: amount, rate: rate, period: period, periodUnit: periodUnit, taxRate: taxRate)
        } else {
            // 적금 계산
            calculateInstallment(amount: amount, rate: rate, period: period, periodUnit: periodUnit, taxRate: taxRate)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - 계산 함수
    private func calculateDeposit(amount: Double, rate: Double, period: Int, periodUnit: PeriodType, taxRate: Double) {
        // 월 단위로 변환
        let months: Int
        switch periodUnit {
        case .month:
            months = period
        case .year:
            months = period * 12
        }
        
        // 이자 계산 (단리)
        // 연이율(%)을 소수로 변환하고 기간을 년 단위로 계산
        let preInterest = amount * (rate / 100) * (Double(months) / 12)
        let tax = preInterest * taxRate
        let postInterest = preInterest - tax
        let total = amount + postInterest
        
        // 결과 표시
        updateResults(principal: amount, preInterest: preInterest, tax: tax, postInterest: postInterest, total: total)
    }
    
    private func calculateInstallment(amount: Double, rate: Double, period: Int, periodUnit: PeriodType, taxRate: Double) {
        // 월 단위로 변환
        let months: Int
        switch periodUnit {
        case .month:
            months = period
        case .year:
            months = period * 12
        }
        
        // 만기 시 원금
        let principal = amount * Double(months)
        
        // 이자 계산 (단리 - 간소화된 계산식)
        let avgMonths = Double(months + 1) / 2
        let preInterest = amount * avgMonths * rate / 100 * Double(months) / 12
        let tax = preInterest * taxRate
        let postInterest = preInterest - tax
        let total = principal + postInterest
        
        // 결과 표시
        updateResults(principal: principal, preInterest: preInterest, tax: tax, postInterest: postInterest, total: total)
    }
    
    private func updateResults(principal: Double, preInterest: Double, tax: Double, postInterest: Double, total: Double) {
        principalValueLabel.text = principal.formatted()
        preInterestValueLabel.text = preInterest.formatted()
        taxValueLabel.text = tax.formatted()
        postInterestValueLabel.text = postInterest.formatted()
        totalValueLabel.text = total.formatted()
    }
    
    private func resetCalculation() {
        principalValueLabel.text = "0"
        preInterestValueLabel.text = "0"
        taxValueLabel.text = "0"
        postInterestValueLabel.text = "0"
        totalValueLabel.text = "0"
    }
    
//    private func formatCurrency(_ value: Double) -> String {
//        return value.formatted()
////        return numberFormatter.string(from: NSNumber(value: Int(round(value)))) ?? "0"
//    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextField Extension (숫자 포맷팅)
extension CalculatorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 숫자와 소수점만 허용
        if textField == rateTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let text = Double((textField.text!).components(separatedBy: ",").joined())?.formatted()
            self.amountTextField.text = text
        }
        
        // 입력이 종료되면 실시간 계산
        calculateIfPossible()
        
        // 금액 포맷팅 (천 단위 구분)
//        if textField == amountTextField, let text = textField.text, let amount = Double(text.components(separatedBy: ",").joined()) {
//            textField.text = amount.formatted() //formatCurrency(amount)
//        }
    }
}
