//
//  FinancialCompanyType.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

enum FinancialCompanyType: String, CaseIterable {
    case all = "전체"
    case firstBank = "1금융권 은행"
    case secondBank = "저축은행"
    
    var code: String {
        switch self {
        case .all:
            return ""
        case .firstBank:
            return "020000"
        case .secondBank:
            return "030300"
        }
    }
}
