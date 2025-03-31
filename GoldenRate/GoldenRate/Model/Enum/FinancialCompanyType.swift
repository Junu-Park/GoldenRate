//
//  FinancialCompanyType.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

enum FinancialCompanyType: String {
    case firstBank = "020000"
    case secondBank = "030300"
    
    var explain: String {
        switch self {
        case .firstBank:
            return "1금융권 은행"
        case .secondBank:
            return "저축은행"
        }
    }
}
