//
//  RateChartView.swift
//  GoldenRate
//
//  Created by 박준우 on 3/30/25.
//

import Charts
import SwiftUI

struct RateChartView: View {
    
    @State private(set) var rateDataList: [RateChartEntity] = []
    @State private var selectedDate: Date = {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        let middleDay = (calendar.range(of: .day, in: .month, for: Date())?.count ?? 15) / 2
        let value = day >= middleDay ? -2 : -1
        
        return calendar.date(byAdding: .month, value: value, to: Date()) ?? Date()
    }()
    
    var body: some View {
        Chart(self.rateDataList, id: \.date) { data in
            LineMark(x: .value("Date", data.date), y: .value("Rate", data.rate), series: .value("Type", data.type))
                .foregroundStyle(by: .value("Type", data.type))
                .interpolationMethod(.stepEnd)
            
            if self.isSampeYearMonth(self.selectedDate, data.date) {
                PointMark(x: .value("Date", data.date), y: .value("Rate", data.rate))
                    .foregroundStyle(by: .value("Type", data.type))
                    .annotation(position: .top, alignment: .center, spacing: 8) {
                        Text(String(format: "%.1f", data.rate))
                            .font(.caption)
                        
                    }
                    .symbol(by: .value("Type", data.type))
                
                RuleMark(x: .value("Date", data.date))
                    .foregroundStyle(.defaultText)
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [3]))
            }
        }
        .chartForegroundStyleScale { (type: RateType) -> Color in
            switch type {
            case .base:
                return .accent
            case .first:
                return .button
            case .second:
                return .text
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { value in
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date.converToYearMonthString())
                    }
                }
//                AxisGridLine()
//                AxisTick()
            }
        }
        .chartXScale(range: .plotDimension(startPadding: 16, endPadding: 32))
        .chartLegend(position: .top, alignment: .center, spacing: 8)
        .chartOverlay { proxy in
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle()) // 이 부분 없으면 터치 안됨
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let adjustedX = max(16, value.location.x - 32)
                            if let date: Date = proxy.value(atX: adjustedX) {
                                self.selectedDate = date
                            }
                        }
                )
        }
        .chartBackground { proxy in
            let selectedRateList = self.rateDataList.filter { self.isSampeYearMonth(self.selectedDate, $0.date) }
            
            VStack {
                ForEach(selectedRateList, id: \.type) { data in
                    HStack {
                        Text(data.type.rawValue)
                        Text(String(format: "%.1f", data.rate))
                    }
                    .foregroundStyle(data.type == .base ? .accent :
                                             data.type == .first ? .button :
                                             .text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(data.type == .base ? .accent :
                                        data.type == .first ? .button :
                                        .text)
                    )
                }
                Spacer()
            }
            .padding(.top, 32)
        }
//        .chartXSelection(value: self.$selectedDate2) // iOS 17.0
        /*
        .chartGesture { proxy in // iOS 17.0
            DragGesture()
        }
        */
    }
}

#Preview {
    let data = [
        RateChartEntity(date: "202411".convertToYearMonthDate(), rate: 3.5, type: .base),
        RateChartEntity(date: "202411".convertToYearMonthDate(), rate: 3.8, type: .first),
        RateChartEntity(date: "202411".convertToYearMonthDate(), rate: 4.2, type: .second),
        RateChartEntity(date: "202412".convertToYearMonthDate(), rate: 3.4, type: .base),
        RateChartEntity(date: "202412".convertToYearMonthDate(), rate: 3.7, type: .first),
        RateChartEntity(date: "202412".convertToYearMonthDate(), rate: 4.1, type: .second),
        RateChartEntity(date: "202501".convertToYearMonthDate(), rate: 3.3, type: .base),
        RateChartEntity(date: "202501".convertToYearMonthDate(), rate: 3.6, type: .first),
        RateChartEntity(date: "202501".convertToYearMonthDate(), rate: 4.0, type: .second),
        RateChartEntity(date: "202502".convertToYearMonthDate(), rate: 3.2, type: .base),
        RateChartEntity(date: "202502".convertToYearMonthDate(), rate: 3.5, type: .first),
        RateChartEntity(date: "202502".convertToYearMonthDate(), rate: 3.9, type: .second)
        ]
    
    RateChartView(rateDataList: data)
}

extension RateChartView {
    func isSampeYearMonth(_ selectedDate: Date, _ dataDate: Date) -> Bool {
        
        let calendar = Calendar.current
        var selectedDateCalendar = calendar.dateComponents([.year,.month, .day], from: selectedDate)
        let dataDateCalendar = calendar.dateComponents([.year,.month], from: dataDate)
        
        let selectedDateMonthDayCount = calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 30
        let selectedDateMiddleDay = selectedDateMonthDayCount/2
        
        let isNextMonth = selectedDateCalendar.day ?? 15 >= selectedDateMiddleDay
        
        if let selectedMonth = selectedDateCalendar.month, isNextMonth {
            if let selectedYear = selectedDateCalendar.year, selectedMonth == 12 {
                selectedDateCalendar.year = selectedYear + 1
                selectedDateCalendar.month = 1
            } else {
                selectedDateCalendar.month = selectedMonth + 1
            }
        }
        
        return (selectedDateCalendar.year == dataDateCalendar.year) && (selectedDateCalendar.month == dataDateCalendar.month)
    }
}

extension String {
    func convertToYearMonthDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        return formatter.date(from: self) ?? Date()
    }
}

extension Date {
    func converToYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.M"
        
        return formatter.string(from: self)
    }
}
