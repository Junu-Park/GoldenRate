//
//  RateType.swift
//  GoldenRate
//
//  Created by 박준우 on 3/28/25.
//

import Charts
import Foundation

enum RateType: String, Plottable {
    case base = "기준금리"
    case first = "1금융권 예금금리"
    case second = "2금융권 예금금리"
}
