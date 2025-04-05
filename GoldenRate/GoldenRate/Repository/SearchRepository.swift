//
//  SearchRepository.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

protocol SearchRepository {
    func getDepositProduct(type: FinancialCompanyType) async throws -> DepositProductResponseDTO
    func getSavingProduct(type: FinancialCompanyType) async throws -> SavingProductResponseDTO
}

struct RealSearchRepository: SearchRepository {
    func getDepositProduct(type: FinancialCompanyType) async throws -> DepositProductResponseDTO {
        do {
            switch type {
            case .all:
                let first: DepositProductResponseDTO = try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
                let second: DepositProductResponseDTO = try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
                
                var totalInfoList = first.result.depositProductInfoList
                totalInfoList.append(contentsOf: second.result.depositProductInfoList)
                var totalRateList = first.result.depositProductRateInfoList
                totalRateList.append(contentsOf: second.result.depositProductRateInfoList)
                
                return DepositProductResponseDTO(result: DepositProductResult(prdt_div: first.result.prdt_div, total_count: first.result.total_count + second.result.total_count, max_page_no: 1, now_page_no: 1, err_cd: first.result.err_cd, err_msg: first.result.err_msg, depositProductInfoList: totalInfoList, depositProductRateInfoList: totalRateList))
            case .firstBank:
                return try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
            case .secondBank:
                return try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
            }
        } catch {
            throw error
        }
    }
    
    func getSavingProduct(type: FinancialCompanyType) async throws -> SavingProductResponseDTO {
        do {
            switch type {
            case .all:
                let first: SavingProductResponseDTO = try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
                let second: SavingProductResponseDTO = try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
                
                var totalInfoList = first.result.savingProductInfoList
                totalInfoList.append(contentsOf: second.result.savingProductInfoList)
                var totalRateList = first.result.savingProductRateInfoList
                totalRateList.append(contentsOf: second.result.savingProductRateInfoList)
                
                return SavingProductResponseDTO(result: SavingProductResult(prdt_div: first.result.prdt_div, total_count: first.result.total_count + second.result.total_count, max_page_no: 1, now_page_no: 1, err_cd: first.result.err_cd, err_msg: first.result.err_msg, savingProductInfoList: totalInfoList, savingProductRateInfoList: totalRateList))
            case .firstBank:
                return try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
            case .secondBank:
                return try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
            }
        } catch {
            throw error
        }
    }
}
