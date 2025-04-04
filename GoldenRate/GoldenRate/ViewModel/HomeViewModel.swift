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
        var getDepositProductTopData: AnyPublisher<Void, Never>
        var getSavingProductTopData: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var rateChartData: AnyPublisher<[RateChartEntity], Never>
        var depositProductTopData: AnyPublisher<[DepositProductEntity], Never>
        var savingProductTopData: AnyPublisher<[SavingProductEntity], Never>
    }
    
    private let repository: HomeRepository
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func tranform(input: Input) -> Output {
        let rateChartData = CurrentValueSubject<[RateChartEntity], Never>([])
        let depositProductTopData = CurrentValueSubject<[DepositProductEntity], Never>([])
        let savingProductTopData = CurrentValueSubject<[SavingProductEntity], Never>([])
        
        input.getRateChartData
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                Task {
                    do {
                        let (baseRateDTO, firstRateDTO, secondRateDTO) = try await self.fetchRateDTO()
                        
                        let baseRateEntity = baseRateDTO.statisticSearch.row.map { RateChartEntity(date: $0.time.convertToDate(format: .yyyyMM), rate: Double($0.dataValue) ?? 0.0, type: .base) }
                        let firstRateEntity = firstRateDTO.statisticSearch.row.map { RateChartEntity(date: $0.time.convertToDate(format: .yyyyMM), rate: Double($0.dataValue) ?? 0.0, type: .first) }
                        let secondRateEntity = secondRateDTO.statisticSearch.row.map { RateChartEntity(date: $0.time.convertToDate(format: .yyyyMM), rate: Double($0.dataValue) ?? 0.0, type: .second) }
                        
                        rateChartData.send(baseRateEntity + firstRateEntity + secondRateEntity)
                    } catch {
                        // TODO: 에러처리
                        print(error)
                    }
                }
            }
            .store(in: &self.cancellable)
        
        input.getDepositProductTopData
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                Task {
                    do {
                        let (firstDepositDTO, secondDepositDTO) = try await self.fetchDepositDTO()
                        
                        let firstDepositEntity = firstDepositDTO.convertToEntityArray()
                        
                        let secondDepositEntity = secondDepositDTO.convertToEntityArray()
                        
                        let topDepositEntity = Array((firstDepositEntity + secondDepositEntity))
                            .filter({ self.getMaxValue(entity: $0) != 0 })
                            .sorted(by: { self.getMaxValue(entity: $0) > self.getMaxValue(entity: $1) })
                        
                        depositProductTopData.send(Array(topDepositEntity[0...2]))
                    } catch {
                        // TODO: 에러처리
                        print(error)
                    }
                }
            }
            .store(in: &self.cancellable)
        
        input.getSavingProductTopData
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                Task {
                    do {
                        let (firstSavingDTO, secondSavingDTO) = try await self.fetchSavingDTO()

                        let firstSavingEntity = firstSavingDTO.convertToEntityArray()
 
                        let secondSavingEntity = secondSavingDTO.convertToEntityArray()
                        
                        let topSavingEntity = Array((firstSavingEntity + secondSavingEntity))
                            .filter({ self.getMaxValue(entity: $0) != 0 })
                            .sorted(by: { self.getMaxValue(entity: $0) > self.getMaxValue(entity: $1) })
                        
                        savingProductTopData.send(Array(topSavingEntity[0...2]))
                    } catch {
                        // TODO: 에러처리
                        print(error)
                    }
                }
            }
            .store(in: &self.cancellable)
        
        return Output(rateChartData: rateChartData.eraseToAnyPublisher(), depositProductTopData: depositProductTopData.eraseToAnyPublisher(), savingProductTopData: savingProductTopData.eraseToAnyPublisher())
    }
}

extension HomeViewModel {
    private func fetchRateDTO() async throws -> (RateResponseDTO, RateResponseDTO, RateResponseDTO) {
        async let baseRate = try await self.repository.getRate(type: .base)
        
        async let firstRate = try await self.repository.getRate(type: .first)
        
        async let secondRate = try await self.repository.getRate(type: .second)

        return try await (baseRate, firstRate, secondRate)
    }
    
    private func fetchDepositDTO() async throws -> (DepositProductResponseDTO, DepositProductResponseDTO) {
        async let firstDeposit = try await self.repository.getDepositProduct(type: .firstBank)
        
        async let secondDeposit = try await self.repository.getDepositProduct(type: .secondBank)

        return try await (firstDeposit, secondDeposit)
    }
    
    private func fetchSavingDTO() async throws -> (SavingProductResponseDTO, SavingProductResponseDTO) {
        async let firstSaving = try await self.repository.getSavingProduct(type: .firstBank)
        
        async let secondSaving = try await self.repository.getSavingProduct(type: .secondBank)

        return try await (firstSaving, secondSaving)
    }
    
    private func getMaxValue(entity: DepositProductEntity) -> Double {
        let simpleMax = entity.depositSimpleRateList[12]?.max() ?? 0
        let compoundMax = entity.depositCompoundRateList[12]?.max() ?? 0
        return max(simpleMax, compoundMax)
    }
    
    private func getMaxValue(entity: SavingProductEntity) -> Double {
        let simpleMax = entity.savingSimpleRateList[12]?.max() ?? 0
        let compoundMax = entity.savingCompoundRateList[12]?.max() ?? 0
        return max(simpleMax, compoundMax)
    }
}
