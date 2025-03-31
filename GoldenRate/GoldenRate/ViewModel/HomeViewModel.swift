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
            .sink { _ in
                let baseRate = self.repository.getRate(type: .base).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .base) }
                let firstRate = self.repository.getRate(type: .first).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .first) }
                let secondRate = self.repository.getRate(type: .second).statisticSearch.row.map { RateChartEntity(date: $0.TIME.convertToYearMonthDate(), rate: Double($0.DATA_VALUE) ?? 0.0, type: .second) }
                
                rateChartData.send(baseRate + firstRate + secondRate)
            }
            .store(in: &self.cancellable)
        
        input.getDepositProductTopData
            .sink { _ in
                let firstDepositProductData = self.repository.getDepositProduct(type: .firstBank)
                let firstDepositProductEntityArray = self.converToDepositProductEntityArray(data: firstDepositProductData)
                
                let secondDepositProduct = self.repository.getDepositProduct(type: .secondBank)
                let secondDepositProductEntityArray = self.converToDepositProductEntityArray(data: secondDepositProduct)
                
                let topDepositProductEntityArray = Array((firstDepositProductEntityArray + secondDepositProductEntityArray).filter { $0.depositRateList[12] != nil }.sorted(by: { $0.depositRateList[12]!.last! > $1.depositRateList[12]!.last! })[0...2])
                
                depositProductTopData.send(topDepositProductEntityArray)
            }
            .store(in: &self.cancellable)
        
        input.getSavingProductTopData
            .sink { _ in
                let firstSavingProductData = self.repository.getSavingProduct(type: .firstBank)
                let firstSavingProductEntityArray = self.converToSavingProductEntityArray(data: firstSavingProductData)
                
                let secondSavingProduct = self.repository.getSavingProduct(type: .secondBank)
                let secondSavingProductEntityArray = self.converToSavingProductEntityArray(data: secondSavingProduct)
                
                let topSavingProductEntityArray = Array((firstSavingProductEntityArray + secondSavingProductEntityArray).filter { $0.savingRateList[12] != nil }.sorted(by: { $0.savingRateList[12]!.last! > $1.savingRateList[12]!.last! })[0...2])
                
                savingProductTopData.send(topSavingProductEntityArray)
            }
            .store(in: &self.cancellable)
        
        return Output(rateChartData: rateChartData.eraseToAnyPublisher(), depositProductTopData: depositProductTopData.eraseToAnyPublisher(), savingProductTopData: savingProductTopData.eraseToAnyPublisher())
    }
}

extension HomeViewModel {
    private func converToDepositProductEntityArray(data: DepositProductResponseDTO) -> [DepositProductEntity] {
        return data.result.depositProductInfoList.map { info in
            
            return DepositProductEntity(
                id: info.productCode,
                name: info.productName,
                companyID: info.companyCode,
                companyName: info.companyName,
                joinWay: info.join_way.split(separator: ",").map { String($0) },
                preferentialCondition: info.preferentialCondition,
                joinRestirct: JoinRestrictType.init(rawValue: Int(info.joinRestrict)!) ?? .noRestrict,
                joinTarget: info.joinTarget,
                note: info.etc_note,
                rateMethod: data.result.depositProductRateInfoList.first(where: { $0.productCode == info.productCode })?.rateMethod ?? "알 수 없음",
                depositAmountLimit: info.max_limit ?? 0,
                depositMonth: data.result.depositProductRateInfoList.filter({ $0.productCode == info.productCode }).map { Int($0.depositMonth) ?? 0 },
                depositRateList: data.result.depositProductRateInfoList.filter({ $0.productCode == info.productCode && $0.baseRate != nil && $0.highestRate != nil}).reduce(into: [:]) { result, info in
                    result[Int(info.depositMonth)!] = [info.baseRate!, info.highestRate!]
                }
            )
        }
    }
    
    private func converToSavingProductEntityArray(data: SavingProductResponseDTO) -> [SavingProductEntity] {
        return data.result.savingProductInfoList.map { info in
            
            return SavingProductEntity(
                id: info.productCode,
                name: info.productName,
                companyID: info.companyCode,
                companyName: info.companyName,
                joinWay: info.join_way.split(separator: ",").map { String($0) },
                preferentialCondition: info.preferentialCondition,
                joinRestirct: JoinRestrictType.init(rawValue: Int(info.joinRestrict)!) ?? .noRestrict,
                joinTarget: info.joinTarget,
                note: info.etc_note,
                rateMethod: data.result.savingProductRateInfoList.first(where: { $0.productCode == info.productCode })?.rateMethod ?? "알 수 없음",
                savingMethod: data.result.savingProductRateInfoList.first(where: { $0.productCode == info.productCode })?.savingMethod ?? "알 수 없음",
                savingAmountLimit: info.max_limit ?? 0,
                savingMonth: data.result.savingProductRateInfoList.filter({ $0.productCode == info.productCode }).map { Int($0.savingMonth) ?? 0 },
                savingRateList: data.result.savingProductRateInfoList.filter({ $0.productCode == info.productCode && $0.baseRate != nil && $0.highestRate != nil}).reduce(into: [:]) { result, info in
                    result[Int(info.savingMonth)!] = [info.baseRate!, info.highestRate!]
                }
            )
        }
    }
}
