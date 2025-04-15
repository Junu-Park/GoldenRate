//
//  RenewalCalculatorViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/27/25.
//

import Combine
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
    
    private let viewModel: CalculatorViewModel
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
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
    }
    
    override func bind() {
        let productType = CurrentValueSubject<ProductType, Never>(.deposit)
        let amount = CurrentValueSubject<Double, Never>(0)
        let interestRate = CurrentValueSubject<Double, Never>(0)
        let period = CurrentValueSubject<Double, Never>(0)
        let periodType = CurrentValueSubject<PeriodType, Never>(.year)
        let taxType = CurrentValueSubject<TaxType, Never>(.general)
        
        self.productTypeSegmentedControl
            .publisher
            .sink { type in
                self.dismissKeyboard()
                self.amountTextField.setView(calculatorTextFieldType: .amount(productType: type))
                productType.send(type)
            }
            .store(in: &self.cancellables)
        
        self.amountTextField
            .publisher
            .sink { value in
                amount.send(Double(value) ?? 0)
            }
            .store(in: &self.cancellables)
        
        self.interestRateTextField
            .publisher
            .sink { value in
                interestRate.send(Double(value) ?? 0)
            }
            .store(in: &self.cancellables)
        
        self.periodTextField
            .publisher
            .sink { value in
                period.send(Double(value) ?? 0)
            }
            .store(in: &self.cancellables)
        
        self.periodTypeSegmentedControl
            .publisher
            .sink { type in
                self.dismissKeyboard()
                self.periodTextField.setView(calculatorTextFieldType: .period(periodType: type))
                periodType.send(type)
            }
            .store(in: &self.cancellables)
        
        self.taxTypeSegmentedControl
            .publisher
            .sink { type in
                self.dismissKeyboard()
                taxType.send(type)
            }
            .store(in: &self.cancellables)
        
        let input = CalculatorViewModel.Input(
            productType: productType.eraseToAnyPublisher(),
            amount: amount.eraseToAnyPublisher(),
            interestRate: interestRate.eraseToAnyPublisher(),
            period: period.eraseToAnyPublisher(),
            periodType: periodType.eraseToAnyPublisher(),
            taxType: taxType.eraseToAnyPublisher()
        )
        let output = self.viewModel.transform(input: input)
        
        let firstCombineLatest = Publishers.CombineLatest3(output.principalAmount, output.preTaxInterest, output.tax)
        let secondCombineLatest = Publishers.CombineLatest(output.afterTaxInterest, output.total)
        firstCombineLatest.combineLatest(secondCombineLatest)
            .receive(on: DispatchQueue.main)
            .map { (first, second) -> (String, String, String, String, String) in
                
                return (first.0, first.1, first.2, second.0, second.1)
            }
            .sink { principal, preTaxInterest, tax, afterTaxInterest, total in
                let taxType = self.taxTypeSegmentedControl.items[self.taxTypeSegmentedControl.selectedSegmentIndex]
                self.resultView.setView(taxType: taxType, principal: principal, preTaxInterest: preTaxInterest, tax: tax, afterTaxInterest: afterTaxInterest, total: total)
            }
            .store(in: &self.cancellables)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
