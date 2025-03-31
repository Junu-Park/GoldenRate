//
//  JoinRestrictType.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

enum JoinRestrictType: Int {
    case noRestrict = 1
    case commonPeopleOnly = 2
    case someRestrict = 3
    
    var explain: String {
        switch self {
        case .noRestrict:
            return "제한없음"
        case .commonPeopleOnly:
            return "서민전용"
        case .someRestrict:
            return "일부제한"
        }
    }
}
