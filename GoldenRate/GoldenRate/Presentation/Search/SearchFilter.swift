//
//  SearchFilter.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

struct SearchFilter {
    var productType: ProductType = .deposit
    var financialCompanyType: FinancialCompanyType = .all
    var interestRateType: InterestRateType = .all
    var productSortType: ProductSortType = .basic
    var searchText: String = ""
    
    var summaryString: String {
        return "은행: \(self.financialCompanyType.rawValue) / 이자 방식: \(self.interestRateType.rawValue) / 정렬: \(self.productSortType.rawValue)"
    }
}
