//
//  HomeViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 3/30/25.
//

import Combine
import Foundation

final class HomeViewModel: ViewModel {
    struct Input {
        var getRateChartData: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var rateChartData: AnyPublisher<[RateChartEntity], Never>
    }
    
    private let repository: HomeRepository
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func tranform(input: Input) -> Output {
        let rateChartData = CurrentValueSubject<[RateChartEntity], Never>([])
        
        input.getRateChartData
            .sink { _ in
                let baseRate = self.repository.getRate(type: .base).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .base) }
                let firstRate = self.repository.getRate(type: .first).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .first) }
                let secondRate = self.repository.getRate(type: .second).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .second) }
                
                rateChartData.send(baseRate + firstRate + secondRate)
            }
            .store(in: &self.cancellable)
        
        return Output(rateChartData: rateChartData.eraseToAnyPublisher())
    }
}
