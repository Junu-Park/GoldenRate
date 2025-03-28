//
//  +String.swift
//  GoldenRate
//
//  Created by 박준우 on 4/7/25.
//

import Foundation

extension String {
    func convertToYearMonthDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        return formatter.date(from: self) ?? Date()
    }
}
