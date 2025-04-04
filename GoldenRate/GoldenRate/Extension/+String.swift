//
//  +String.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import Foundation

extension String {
    func convertToDate(format: DateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.date(from: self) ?? Date()
    }
}
