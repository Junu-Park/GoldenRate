//
//  CalculatorViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/12/25.
//

import Combine

final class CalculatorViewModel: ViewModel {
    struct Input {
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
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let principalAmount = CurrentValueSubject<String, Never>("0원")
        let preTaxInterest = CurrentValueSubject<String, Never>("0원")
        let tax = CurrentValueSubject<String, Never>("0원")
        let afterTaxInterest = CurrentValueSubject<String, Never>("0원")
        let total = CurrentValueSubject<String, Never>("0원")
        
        // TODO: Input 로직 만들기
        
        return Output(
            principalAmount: principalAmount.eraseToAnyPublisher(),
            preTaxInterest: preTaxInterest.eraseToAnyPublisher(),
            tax: tax.eraseToAnyPublisher(),
            afterTaxInterest: afterTaxInterest.eraseToAnyPublisher(),
            total: total.eraseToAnyPublisher()
        )
    }
}
