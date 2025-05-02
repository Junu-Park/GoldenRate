//
//  RateChartView.swift
//  GoldenRate
//
//  Created by 박준우 on 3/29/25.
//

import Charts
import SwiftUI

import FirebaseAnalytics

struct RateChartView: View {
    
    @State private var rateDataList: [RateChartEntity]
    @State private var selectedDate: Date = {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        let middleDay = (calendar.range(of: .day, in: .month, for: Date())?.count ?? 30) / 2
        let value = day >= middleDay ? -2 : -1
        
        return calendar.date(byAdding: .month, value: value, to: Date()) ?? Date()
    }()
    
    init(rateDataList: [RateChartEntity]) {
        self.rateDataList = rateDataList
    }
    
    var body: some View {
        Chart(self.rateDataList, id: \.date) { data in
            if data.date >= self.getMinMaxDate().0 {
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Rate", data.rate),
                    series: .value("Type", data.type)
                )
                .foregroundStyle(by: .value("Type", data.type))
                .interpolationMethod(.stepEnd)
            }
            
            if self.isSameDate(selected: self.selectedDate, data: data.date) {
                let filteredData = self.rateDataList.filter {
                    self.isSameDate(selected: self.selectedDate, data: $0.date)
                }
                
                ForEach(filteredData, id: \.type) { data in
                    PointMark(
                        x: .value("Date", data.date),
                        y: .value("Rate", data.rate)
                    )
                    .foregroundStyle(by: .value("Type", data.type))
                    .annotation(position: .bottomTrailing, alignment: .center, spacing: 8) {
                        Text(String(format: "%.2f%%", data.rate))
                            .foregroundStyle(Color(uiColor: UIColor.defaultText))
                            .font(.bold10)
                    }
                }
                
                RuleMark(x: .value("Date", data.date))
                    .foregroundStyle(.defaultText)
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [3]))
            }
        }
        .padding(16)
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
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let data = value.as(Double.self) {
                        Text(String(format: "%.1f%%", data))
                            .foregroundStyle(Color(uiColor: UIColor.defaultText))
                            .font(.regular10)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, values: .stride(by: .month)) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(self.converToYearMonthString(date))
                            .foregroundStyle(Color(uiColor: UIColor.defaultText))
                            .font(.regular10)
                    }
                }
            }
        }
        .chartYScale(domain: {
            let (min, max) = self.getMinMaxRate()
            
            return [min - 0.5, max + 0.5]
        }())
        .chartXScale(domain: {
            let (min, max) = self.getMinMaxDate()
            
            return [min, max]
        }(), range: .plotDimension(startPadding: 16, endPadding: 32))
        .chartLegend(position: .top, alignment: .center, spacing: 16)
        .chartOverlay { proxy in
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle()) // 이 부분 없으면 터치 안됨
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            Analytics.logEvent("RateChartView_Drag", parameters: nil)
                            if let data = proxy.value(atX: value.location.x, as: Date.self) {
                                let (min, max) = self.getMinMaxDate()
                                
                                if min > data {
                                    self.selectedDate = min
                                } else if max < data {
                                    self.selectedDate = max
                                } else {
                                    self.selectedDate = data
                                }
                            }
                        }
                )
        }
        /*
         // iOS 17.0 이상
        .chartXSelection(value: self.$selectedDate2)
        .chartGesture { proxy in
            DragGesture()
        }
        */
    }
}

extension RateChartView {
    private func getMinMaxRate() -> (Double, Double) {
        let filteredRateArr = Dictionary(grouping: rateDataList, by: { $0.type })
        
        let minRate = filteredRateArr.values.compactMap { $0.map(\.rate).min() }.min() ?? 0
        let maxRate = filteredRateArr.values.compactMap { $0.map(\.rate).max() }.max() ?? 0
        
        return (minRate, maxRate)
    }
    
    private func getMinMaxDate() -> (Date, Date) {
        let filteredRateArr = Dictionary(grouping: rateDataList, by: { $0.type })
        
        let minDate = filteredRateArr.values.compactMap { $0.map(\.date).min() }.max() ?? Date()
        let maxDate = filteredRateArr.values.compactMap { $0.map(\.date).max() }.max() ?? Date()
        
        return (minDate, maxDate)
    }
    
    private func adjustDate(_ date: Date = Date()) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let midDay = (calendar.range(of: .day, in: .month, for: date)?.count ?? 30) / 2
        let isAfterMidDay = components.day ?? 15 > midDay
        
        if isAfterMidDay {
            if let day = components.day {
                components.day = day + midDay
            }
        }
        
        return calendar.date(from: components) ?? Date()
    }
    
    private func isSameDate(selected selectedDate: Date, data dataDate: Date) -> Bool {
        let calendar = Calendar.current
        
        let adjustedSelectedDate = self.adjustDate(selectedDate)
        let selectedComponents = calendar.dateComponents([.year, .month], from: adjustedSelectedDate)
        
        let dataComponents = calendar.dateComponents([.year, .month], from: dataDate)
        
        return selectedComponents.year == dataComponents.year && selectedComponents.month == dataComponents.month
    }
    
    private func converToYearMonthString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.M"
        
        return formatter.string(from: date)
    }
}

#Preview {
    let data = [
        RateChartEntity(date: "202412".convertToDate(format: .yyyyMM), rate: 3.5, type: .base),
        RateChartEntity(date: "202412".convertToDate(format: .yyyyMM), rate: 3.8, type: .first),
        RateChartEntity(date: "202412".convertToDate(format: .yyyyMM), rate: 4.2, type: .second),
        RateChartEntity(date: "202501".convertToDate(format: .yyyyMM), rate: 3.4, type: .base),
        RateChartEntity(date: "202501".convertToDate(format: .yyyyMM), rate: 3.7, type: .first),
        RateChartEntity(date: "202501".convertToDate(format: .yyyyMM), rate: 4.1, type: .second),
        RateChartEntity(date: "202502".convertToDate(format: .yyyyMM), rate: 3.3, type: .base),
        RateChartEntity(date: "202502".convertToDate(format: .yyyyMM), rate: 3.6, type: .first),
        RateChartEntity(date: "202502".convertToDate(format: .yyyyMM), rate: 4.0, type: .second),
        RateChartEntity(date: "202503".convertToDate(format: .yyyyMM), rate: 3.2, type: .base),
        RateChartEntity(date: "202503".convertToDate(format: .yyyyMM), rate: 3.5, type: .first),
        RateChartEntity(date: "202503".convertToDate(format: .yyyyMM), rate: 3.9, type: .second)
        ]
    
    RateChartView(rateDataList: data)
}
