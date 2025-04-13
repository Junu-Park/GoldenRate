//
//  GoldenRateWidget.swift
//  GoldenRateWidget
//
//  Created by 박준우 on 4/20/25.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> LatestInterestRateEntry {
        LatestInterestRateEntry(date: .now, entityList: LatestInterestRateEntity.mock)
    }

    func getSnapshot(in context: Context, completion: @escaping (LatestInterestRateEntry) -> ()) {
        let entry = LatestInterestRateEntry(date: Date(), entityList: LatestInterestRateEntity.mock)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            do {
                let dataList = try await WidgetNetworkManager.shared.requestRateDataList()
                let entityList: [LatestInterestRateEntity] = [
                    try convertToEntity(response: dataList[0], type: .base),
                    try convertToEntity(response: dataList[1], type: .first),
                    try convertToEntity(response: dataList[2], type: .second),
                ]
                
                var entries: [LatestInterestRateEntry] = []
                for hourOffset in 0..<5 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: .now)!
                    let entry = LatestInterestRateEntry(date: entryDate, entityList: entityList)
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } catch {
                print("error: \(error)")
                
                let entry = LatestInterestRateEntry(date: Date(), entityList: [])
                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
                completion(timeline)
            }
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    
    func convertToEntity(response: RateResponseDTO, type: LatestRateType) throws -> LatestInterestRateEntity {
        
        let listCount = response.statisticSearch.listTotalCount
        
        var list = response.statisticSearch.row
        
        if listCount == 0 {
            throw NetworkError.noData
        } else if listCount == 1 {
            guard let lastValue = Double(list.last?.dataValue ?? "0") else {
                throw NetworkError.noData
            }
            
            return LatestInterestRateEntity(rateType: type, previousRate: lastValue, currentRate: lastValue)
        } else {
            guard let currentValue = Double(list.popLast()?.dataValue ?? "0"), let previousValue = Double(list.popLast()?.dataValue ?? "0") else {
                throw NetworkError.noData
            }
            
            return LatestInterestRateEntity(rateType: type, previousRate: previousValue, currentRate: currentValue)
        }
    }
}

struct LatestInterestRateEntry: TimelineEntry {
    let date: Date
    let entityList: [LatestInterestRateEntity]
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self.date)
    }
}

struct GoldenRateWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(entry.entityList, id: \.id) { entity in
                LatestRateTextView(data: entity)
            }
            
            Spacer()
            
            Text(entry.getDateString())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(.defaultGray)
                .font(.bold10)
        }
        .shadow(color: .defaultGray, radius: 0.8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(.defaultBackground)
                .shadow(color: .defaultGray, radius: 3)
        }
    }
}

struct GoldenRateWidgetEmptyView: View {
    var body: some View {
        Text("widgetNetworkErrorMessage")
            .multilineTextAlignment(.center)
            .foregroundStyle(.defaultGray)
            .font(.bold12)
            .shadow(color: .defaultGray, radius: 0.8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.defaultBackground)
                    .shadow(color: .defaultGray, radius: 3)
            }
    }
}

struct GoldenRateWidget: Widget {
    let kind: String = "GoldenRateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if !entry.entityList.isEmpty {
                if #available(iOS 17.0, *) {
                    GoldenRateWidgetEntryView(entry: entry)
                        .containerBackground(for: .widget, content: { Color.background })
                        .padding(8)
                } else {
                    GoldenRateWidgetEntryView(entry: entry)
                        .background(Color.background)
                        .padding(8)
                }
            } else {
                if #available(iOS 17.0, *) {
                    GoldenRateWidgetEmptyView()
                        .containerBackground(for: .widget, content: { Color.background })
                        .padding(8)
                } else {
                    GoldenRateWidgetEmptyView()
                        .background(Color.background)
                        .padding(8)
                }
            }
        }
        .configurationDisplayName("goldenRate")
        .description("latestInterestRate")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
    }
}

private struct LatestRateTextView: View {
    
    let data: LatestInterestRateEntity
    
    var body: some View {
        Text(AttributedString(totalString: self.data.rateType.title, totalColor: .defaultGray, totalFont: .bold12, targetString: self.data.rateType.targetTitle, targetColor: self.data.rateType.color, targetFont: .bold12))
        Text(AttributedString(totalString: "\(self.data.changeSymbol()) \(String(format: "%.2f", self.data.currentRate))%", totalColor: .defaultText, totalFont: .bold12, targetString: self.data.changeSymbol(), targetColor: self.data.changeColor(), targetFont: .bold12))
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    GoldenRateWidget()
} timeline: {
    LatestInterestRateEntry(date: .now, entityList: LatestInterestRateEntity.mock)
}
