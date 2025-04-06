//
//  TaxType.swift
//  GoldenRate
//
//  Created by 박준우 on 4/2/25.
//

import Foundation

enum TaxType: String, CaseIterable {
    case general = "일반과세"
    case exemption = "비과세"
    case preferential = "세금우대"
    
    var percent: Double {
        switch self {
        case .general:
            return 15.4
        case .exemption:
            return 0.0
        case .preferential:
            return 9.5
        }
    }
}
