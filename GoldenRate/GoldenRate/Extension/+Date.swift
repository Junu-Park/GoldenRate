//
//  +Date.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import Foundation

extension Date {
    func convertToString(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
    
    func convertTo1YearAgoString(format: DateFormat) -> String {
        let yearAgoCalendar = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: yearAgoCalendar)
    }
}
