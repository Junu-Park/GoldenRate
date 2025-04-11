//
//  RenewalCalculatorViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/27/25.
//

import UIKit

import SnapKit

final class RenewalCalculatorViewController: BaseViewController {

    private let productTypeSegmentedControl: CustomSegmentedControl = CustomSegmentedControl<ProductType>(items: [.deposit, .saving])
    private let amountTextField: CalculatorTextFieldView = CalculatorTextFieldView(calculatorTextFieldType: .amount(productType: .deposit))
    private let interestRateTextField: CalculatorTextFieldView = CalculatorTextFieldView(calculatorTextFieldType: .interestRate)
    private let periodTextField: CalculatorTextFieldView = CalculatorTextFieldView(calculatorTextFieldType: .period(periodType: .month))
    private let periodTypeSegmentedControl: CustomSegmentedControl = CustomSegmentedControl<PeriodType>(items: PeriodType.allCases)
    private let taxTitleLabel: UILabel = UILabel()
    private let taxTypeSegmentedControl: CustomSegmentedControl = CustomSegmentedControl<TaxType>(items: TaxType.allCases)
    private let resultView: CalculatorResultView = CalculatorResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        self.view.addSubviews(self.productTypeSegmentedControl, self.amountTextField, self.interestRateTextField, self.periodTextField, self.periodTypeSegmentedControl, self.taxTitleLabel, self.taxTypeSegmentedControl, self.resultView)
    }
    
    override func configureLayout() {
        self.productTypeSegmentedControl.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        self.amountTextField.snp.makeConstraints {
            $0.top.equalTo(self.productTypeSegmentedControl.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        self.interestRateTextField.snp.makeConstraints {
            $0.top.equalTo(self.amountTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        self.periodTextField.snp.makeConstraints {
            $0.top.equalTo(self.interestRateTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        self.periodTypeSegmentedControl.snp.makeConstraints{
            $0.top.equalTo(self.periodTextField.snp.bottom)
            $0.leading.greaterThanOrEqualToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
        self.taxTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.taxTypeSegmentedControl)
            $0.leading.equalToSuperview().offset(16)
        }
        self.taxTypeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(self.periodTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalTo(self.taxTitleLabel.snp.trailing).offset(32)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
        self.resultView.snp.makeConstraints {
            $0.top.equalTo(self.taxTypeSegmentedControl.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func configureView() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.taxTitleLabel.text = "이자 세율"
        self.taxTitleLabel.font = .bold16
        self.taxTitleLabel.textColor = .text
        
        self.productTypeSegmentedControl.addTarget(self, action: #selector(self.productSegmentValueChanged), for: .valueChanged)
        self.periodTypeSegmentedControl.addTarget(self, action: #selector(self.periodSegmentValueChanged), for: .valueChanged)
        self.taxTypeSegmentedControl.addTarget(self, action: #selector(self.taxSegmentValueChanged), for: .valueChanged)
        
        self.amountTextField.textFieldClosure = { amount in
            let taxValue = TaxType.allCases[self.taxTypeSegmentedControl.selectedSegmentIndex]
            
            guard amount != 0, let interest = self.interestRateTextField.getTextValue(), let period = self.periodTextField.getTextValue() else {
                self.resultView.setView(taxType: taxValue)
                return
            }
            
            let (principal, preTaxInterest, tax, afterTaxInterest, total) = self.calculate(amount: Int(amount), interestRate: Double(interest) ?? 0, period: Int(period) ?? 0)
            
            self.resultView.setView(taxType: taxValue, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
        }
        self.interestRateTextField.textFieldClosure = { interestRate in
            let taxValue = TaxType.allCases[self.taxTypeSegmentedControl.selectedSegmentIndex]
            
            if interestRate == 0 || Int(self.periodTextField.getTextValue() ?? "0") == 0 {
                let amount = Int(self.amountTextField.getTextValue() ?? "0") ?? 0
                
                let productValue = ProductType.allCases[self.productTypeSegmentedControl.selectedSegmentIndex]
                
                if productValue == .saving {
                    let periodValue = Int(self.periodTextField.getTextValue() ?? "0") ?? 0
                    self.resultView.setView(taxType: taxValue, principal: amount * periodValue)
                    return
                }
                
                self.resultView.setView(taxType: taxValue, principal: amount, total: amount)
                return
            }
            
            guard let amount = self.amountTextField.getTextValue(), let period = self.periodTextField.getTextValue() else {
                self.resultView.setView(taxType: taxValue)
                return
            }
            
            let (principal, preTaxInterest, tax, afterTaxInterest, total) = self.calculate(amount: Int(amount) ?? 0, interestRate: interestRate, period: Int(period) ?? 0)
            
            self.resultView.setView(taxType: taxValue, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
        }
        self.periodTextField.textFieldClosure = { period in
            let taxValue = TaxType.allCases[self.taxTypeSegmentedControl.selectedSegmentIndex]
            
            if period == 0 || Int(self.interestRateTextField.getTextValue() ?? "0") == 0 {
                let amount = Int(self.amountTextField.getTextValue() ?? "0") ?? 0
                
                let productValue = ProductType.allCases[self.productTypeSegmentedControl.selectedSegmentIndex]
                
                if productValue == .saving {
                    let periodValue = Int(self.periodTextField.getTextValue() ?? "0") ?? 0
                    self.resultView.setView(taxType: taxValue, principal: amount * periodValue)
                    return
                }
                
                self.resultView.setView(taxType: taxValue, principal: amount, total: amount)
                return
            }
            
            guard let amount = self.amountTextField.getTextValue(), let interest = self.interestRateTextField.getTextValue() else {
                self.resultView.setView(taxType: taxValue)
                return
            }
            
            let (principal, preTaxInterest, tax, afterTaxInterest, total) = self.calculate(amount: Int(amount) ?? 0, interestRate: Double(interest) ?? 0, period: Int(period))
            
            self.resultView.setView(taxType: taxValue, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func productSegmentValueChanged(_ sender: UISegmentedControl) {
        self.dismissKeyboard()
        
        let productValue = ProductType.allCases[sender.selectedSegmentIndex]
        self.amountTextField.setView(calculatorTextFieldType: .amount(productType: productValue))
        self.amountTextField.setTextValue()
        
        self.interestRateTextField.setTextValue()
        
        self.periodTextField.setTextValue()
        
        self.periodTypeSegmentedControl.selectedSegmentIndex = 0
        self.periodTypeSegmentedControl.sendActions(for: .valueChanged)
        
        self.taxTypeSegmentedControl.selectedSegmentIndex = 0
        self.taxTypeSegmentedControl.sendActions(for: .valueChanged)
        
        self.resultView.setView(taxType: .general)
    }
    @objc private func periodSegmentValueChanged(_ sender: UISegmentedControl) {
        self.dismissKeyboard()
        
        let periodValue = PeriodType.allCases[sender.selectedSegmentIndex]
        self.periodTextField.setView(calculatorTextFieldType: .period(periodType: periodValue))
        
        let taxValue = TaxType.allCases[self.taxTypeSegmentedControl.selectedSegmentIndex]
        
        guard let amount = self.amountTextField.getTextValue(), let interest = self.interestRateTextField.getTextValue(), let period = self.periodTextField.getTextValue() else {
            self.resultView.setView(taxType: taxValue)
            return
        }
        
        let (principal, preTaxInterest, tax, afterTaxInterest, total) = self.calculate(amount: Int(amount) ?? 0, interestRate: Double(interest) ?? 0, period: Int(period) ?? 0)
        
        self.resultView.setView(taxType: taxValue, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
    }
    @objc private func taxSegmentValueChanged(_ sender: UISegmentedControl) {
        self.dismissKeyboard()
        
        let taxValue = TaxType.allCases[sender.selectedSegmentIndex]
        
        guard let amount = self.amountTextField.getTextValue(), let interest = self.interestRateTextField.getTextValue(), let period = self.periodTextField.getTextValue() else {
            self.resultView.setView(taxType: taxValue)
            return
        }
        
        let (principal, preTaxInterest, tax, afterTaxInterest, total) = self.calculate(amount: Int(amount) ?? 0, interestRate: Double(interest) ?? 0, period: Int(period) ?? 0)
        
        self.resultView.setView(taxType: taxValue, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
    }
    
    private func calculate(amount: Int, interestRate: Double, period: Int) -> (Int, Int, Int, Int, Int) {
        let interestRateDecimal = interestRate / 100
        let taxRateDecimal = TaxType.allCases[self.taxTypeSegmentedControl.selectedSegmentIndex].percent / 100
        let periodMonth = PeriodType.allCases[self.periodTypeSegmentedControl.selectedSegmentIndex] == .month ? period : period * 12
        
        var principal = 0
        var preTaxInterest = 0
        var tax = 0
        var afterTaxInterest = 0
        var total = 0
        
        switch ProductType.allCases[self.productTypeSegmentedControl.selectedSegmentIndex] {
        case .deposit:
            principal = amount
            preTaxInterest = Int(Double(amount) * interestRateDecimal * (Double(periodMonth) / 12))
            tax = Int(Double(preTaxInterest) * taxRateDecimal)
            afterTaxInterest = preTaxInterest - tax
            total = amount + afterTaxInterest
        case .saving:
            let averageMonth = (periodMonth + 1) / 2
            principal = amount * periodMonth
            preTaxInterest = Int(Double(amount) * Double(averageMonth) * interestRateDecimal * Double(periodMonth) / 12)
            tax = Int(Double(preTaxInterest) * taxRateDecimal)
            afterTaxInterest = preTaxInterest - tax
            total = (amount * periodMonth) + afterTaxInterest
        }
        
        return (principal, preTaxInterest, tax, afterTaxInterest, total)
    }
}
