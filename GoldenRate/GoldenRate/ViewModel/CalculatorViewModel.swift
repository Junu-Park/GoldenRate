//
//  CalculatorViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/12/25.
//

import Combine

final class CalculatorViewModel: ViewModel {
    struct Input {
        var productType: AnyPublisher<ProductType, Never>
        var amount: AnyPublisher<Double, Never>
        var interestRate: AnyPublisher<Double, Never>
        var period: AnyPublisher<Double, Never>
        var periodType: AnyPublisher<PeriodType, Never>
        var taxType: AnyPublisher<TaxType, Never>
    }
    
    struct Output {
        var principalAmount: AnyPublisher<String, Never>
        var preTaxInterest: AnyPublisher<String, Never>
        var tax: AnyPublisher<String, Never>
        var afterTaxInterest: AnyPublisher<String, Never>
        var total: AnyPublisher<String, Never>
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let firstLatestCombine = Publishers.CombineLatest3(input.productType, input.amount, input.interestRate)
        let secondLatestCombine = Publishers.CombineLatest3(input.period, input.periodType, input.taxType)
        let allLatestCombine = firstLatestCombine.combineLatest(secondLatestCombine)
            .map { (first, second) -> (ProductType, Double, Double, Double, PeriodType, TaxType) in
                
                return (first.0, first.1, first.2, second.0, second.1, second.2)
            }
        let calculator = allLatestCombine
            .map { productType, amount, interestRate, period, periodType, taxType in
                
                let (principalAmount, preTaxInterest, tax, afterTaxInterest, total) = self.calculateResult(productType: productType, amount: amount, interestRate: interestRate, period: period, periodType: periodType, taxType: taxType)
                
                return (
                    self.getFormattedCurrency(principalAmount),
                    self.getFormattedCurrency(preTaxInterest),
                    self.getFormattedCurrency(tax),
                    self.getFormattedCurrency(afterTaxInterest),
                    self.getFormattedCurrency(total)
                )
            }
            .share()
        
        return Output(
            principalAmount: calculator.map { $0.0 }.eraseToAnyPublisher(),
            preTaxInterest: calculator.map { $0.1 }.eraseToAnyPublisher(),
            tax: calculator.map { $0.2 }.eraseToAnyPublisher(),
            afterTaxInterest: calculator.map { $0.3 }.eraseToAnyPublisher(),
            total: calculator.map { $0.4 }.eraseToAnyPublisher()
        )
    }
    
    private func calculateResult(productType: ProductType, amount: Double, interestRate: Double, period: Double, periodType: PeriodType, taxType: TaxType) -> (Double, Double, Double, Double, Double) {
        let periodWithMonth = periodType == .year ? period * 12 : period
        let interestRateDecimal = interestRate / 100
        let taxRateDecimal = taxType.percent / 100
        
        let principalAmount = (productType == .deposit) ? amount : amount * period
        var preTaxInterest = amount * interestRateDecimal * (periodWithMonth / 12)
        if productType == .saving {
            let averagePeriodMonth = (periodWithMonth + 1) / 2
            
            preTaxInterest *= averagePeriodMonth
        }
        let tax = preTaxInterest * taxRateDecimal
        let afterTaxInterest = preTaxInterest - tax
        let total = principalAmount + afterTaxInterest
        
        return (principalAmount, preTaxInterest, tax, afterTaxInterest, total)
    }
    
    private func getFormattedCurrency(_ number: Double) -> String {
        return "\(Int(number).formatted())원"
    }
}
