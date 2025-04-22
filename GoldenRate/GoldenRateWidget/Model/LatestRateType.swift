//
//  LatestRateType.swift
//  GoldenRate
//
//  Created by 박준우 on 4/20/25.
//

import SwiftUI

enum LatestRateType {
    case base
    case first
    case second
    
    var title: String {
        switch self {
        case .base:
            return "◉ 기준금리"
        case .first:
            return "◉ 1금융 예금금리"
        case .second:
            return "◉ 2금융 예금금리"
        }
    }
    
    var targetTitle: String {
        switch self {
        case .base:
            return "◉ 기준"
        case .first:
            return "◉ 1금융"
        case .second:
            return "◉ 2금융"
        }
    }
    
    var color: Color {
        switch self {
        case .base:
            return .accent
        case .first:
            return .button
        case .second:
            return .text
        }
    }
}
