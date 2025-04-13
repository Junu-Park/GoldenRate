//
//  SearchViewModel.swift
//  GoldenRate
//
//  Created by 박준우 on 4/5/25.
//

import Combine
import Foundation

final class SearchViewModel: ViewModel {
    struct Input {
        var initProductData: AnyPublisher<Void, Never>
        var getProductData: AnyPublisher<(SearchFilter, ProductType), Never>
    }
    
    struct Output {
        var depositProductData: AnyPublisher<[DepositProductEntity], Never>
        var savingProductData: AnyPublisher<[SavingProductEntity], Never>
    }
    
    private var depositEntityDataArr: [DepositProductEntity] = []
    private var savingEntityDataArr: [SavingProductEntity] = []
    private var filter: SearchFilter = SearchFilter()
    private let repository: SearchRepository
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(repository: SearchRepository) {
        self.repository = repository
        // TODO: ViewModel이 init될 때 데이터를 불러올지 고민해보기
        /*
        Task {
            do {
                let firstDepositProductData = try await self.repository.getDepositProduct(type: .firstBank)
                let firstDepositProductEntityArray = self.converToDepositProductEntityArray(data: firstDepositProductData)
                
                let secondDepositProduct = try await self.repository.getDepositProduct(type: .secondBank)
                let secondDepositProductEntityArray = self.converToDepositProductEntityArray(data: secondDepositProduct)
                
                self.depositEntityDataArr = Array((firstDepositProductEntityArray + secondDepositProductEntityArray))
            } catch {
                // TODO: 에러처리
                print(error)
            }
        }
        
        Task {
            do {
                let firstSavingProductData = try await self.repository.getSavingProduct(type: .firstBank)
                let firstSavingProductEntityArray = self.converToSavingProductEntityArray(data: firstSavingProductData)
                
                let secondSavingProduct = try await self.repository.getSavingProduct(type: .secondBank)
                let secondSavingProductEntityArray = self.converToSavingProductEntityArray(data: secondSavingProduct)
                
                self.savingEntityDataArr = Array((firstSavingProductEntityArray + secondSavingProductEntityArray))
            } catch {
                // TODO: 에러처리
                print(error)
            }
        }
        */
    }
    
    func transform(input: Input) -> Output {
        let depositProductData = PassthroughSubject<[DepositProductEntity], Never>()
        let savingProductData = PassthroughSubject<[SavingProductEntity], Never>()
        
        input.initProductData
            .sink { [weak self] _ in
                guard let self else {
                    return
                }
                Task {
                    do {
                        let (depositDTOArr, savingDTOArr) = try await self.fetchData()
                        
                        depositDTOArr.forEach { data in
                            self.depositEntityDataArr.append(contentsOf: data.convertToEntityArray())
                        }
                        
                        savingDTOArr.forEach { data in
                            self.savingEntityDataArr.append(contentsOf: data.convertToEntityArray())
                        }
                        
                        switch self.filter.productType{
                        case .deposit:
                            depositProductData.send(self.depositEntityDataArr)
                        case .saving:
                            savingProductData.send(self.savingEntityDataArr)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: &self.cancellables)
        
        input.getProductData
            .sink { [weak self] (searchFilter, productType) in
                guard let self else {
                    return
                }
                self.filter = searchFilter
                
                switch productType {
                case .deposit:
                    if !self.depositEntityDataArr.isEmpty {
                        depositProductData.send(self.filteringDepositData())
                    }
                case .saving:
                    if !self.depositEntityDataArr.isEmpty {
                        savingProductData.send(self.filteringSavingData())
                    }
                }
            }
            .store(in: &self.cancellables)
        
        return Output(depositProductData: depositProductData.eraseToAnyPublisher(), savingProductData: savingProductData.eraseToAnyPublisher())
    }
}

extension SearchViewModel {
    private func fetchData() async throws -> ([DepositProductResponseDTO], [SavingProductResponseDTO]) {
        async let firstDepositProductData = try await self.repository.getDepositProduct(type: .firstBank)
        
        async let secondDepositProduct = try await self.repository.getDepositProduct(type: .secondBank)
        
        async let firstSavingProductData = try await self.repository.getSavingProduct(type: .firstBank)
        
        async let secondSavingProduct = try await self.repository.getSavingProduct(type: .secondBank)
        
        return try await ([firstDepositProductData, secondDepositProduct], [firstSavingProductData, secondSavingProduct])
    }
    
    // TODO: Lazy Collection 고려해보기
    private func filteringDepositData() -> [DepositProductEntity] {
        let financialCompanyType = self.filter.financialCompanyType
        let interestRateType = self.filter.interestRateType
        let searchText = self.filter.searchText.lowercased()
        
        var filteredData = self.depositEntityDataArr.filter { data in
            if financialCompanyType != .all {
                switch financialCompanyType {
                case .firstBank:
                    if FirstBankType(rawValue: data.companyID) == nil {
                        return false
                    } else {
                        break
                    }
                case .secondBank:
                    if FirstBankType(rawValue: data.companyID) == nil {
                        break
                    } else {
                        return false
                    }
                default:
                    break
                }
            }
            
            if interestRateType != .all && !data.interestRateType.contains(interestRateType) {
                return false
            }
            
            if !searchText.isEmpty {
                if !data.companyName.lowercased().contains(searchText.lowercased()) && !data.name.lowercased().contains(searchText.lowercased()) {
                    return false
                }
            }
            
            return true
        }
        
        if self.filter.productSortType == .highestRate {
            filteredData.sort { first, second in
                let firstMaxSimpleRate = first.depositSimpleRateList.values.flatMap { $0 }.max() ?? 0
                
                let firstMaxCompoundRate = first.depositCompoundRateList.values.flatMap { $0 }.max() ?? 0
                
                let secondMaxSimpleRate = second.depositSimpleRateList.values.flatMap { $0 }.max() ?? 0
                
                let secondMaxCompoundRate = second.depositCompoundRateList.values.flatMap { $0 }.max() ?? 0
                
                return (max(firstMaxSimpleRate, firstMaxCompoundRate)) > (max(secondMaxSimpleRate, secondMaxCompoundRate))
            }
        } else {
            filteredData.sort(by: { $0.companyID < $1.companyID })
        }
        
        return filteredData
    }
    
    // TODO: Lazy Collection 고려해보기
    private func filteringSavingData() -> [SavingProductEntity] {
        let financialCompanyType = self.filter.financialCompanyType
        let interestRateType = self.filter.interestRateType
        let searchText = self.filter.searchText.lowercased()
        
        var filteredData = self.savingEntityDataArr.filter { data in
            if financialCompanyType != .all {
                switch financialCompanyType {
                case .firstBank:
                    if FirstBankType(rawValue: data.companyID) == nil {
                        return false
                    } else {
                        break
                    }
                case .secondBank:
                    if FirstBankType(rawValue: data.companyID) == nil {
                        break
                    } else {
                        return false
                    }
                default:
                    break
                }
            }
            
            if interestRateType != .all && !data.interestRateType.contains(interestRateType) {
                return false
            }
            
            if !searchText.isEmpty {
                if !data.companyName.lowercased().contains(searchText) && !data.name.lowercased().contains(searchText) {
                    return false
                }
            }
            
            return true
        }
        
        if self.filter.productSortType == .highestRate {
            filteredData.sort { first, second in
                
                let firstMaxSimpleRate = first.savingSimpleRateList.values.flatMap { $0 }.max() ?? 0
                
                let firstMaxCompoundRate = first.savingCompoundRateList.values.flatMap { $0 }.max() ?? 0
                
                let secondMaxSimpleRate = second.savingSimpleRateList.values.flatMap { $0 }.max() ?? 0
                
                let secondMaxCompoundRate = second.savingCompoundRateList.values.flatMap { $0 }.max() ?? 0
                
                return (max(firstMaxSimpleRate, firstMaxCompoundRate)) > (max(secondMaxSimpleRate, secondMaxCompoundRate))
            }
        } else {
            filteredData.sort(by: { $0.companyID < $1.companyID })
        }
        
        return filteredData
    }
}
