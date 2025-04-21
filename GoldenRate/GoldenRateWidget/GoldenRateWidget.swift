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
        var entries: [LatestInterestRateEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = LatestInterestRateEntry(date: entryDate, entityList: LatestInterestRateEntity.mock)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct LatestInterestRateEntry: TimelineEntry {
    let date: Date
    let entityList: [LatestInterestRateEntity]
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        return formatter.string(from: self.date)
    }
}

struct GoldenRateWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(entry.entityList, id: \.rateType) { entity in
                LatestRateTextView(data: entity)
            }

            Text(entry.getDateString())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(.defaultGray)
                .font(.bold10)
        }
        .shadow(color: .defaultGray, radius: 0.8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.defaultBackground)
                .shadow(color: .defaultGray, radius: 3)
        }
    }
}

struct GoldenRateWidget: Widget {
    let kind: String = "GoldenRateWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                GoldenRateWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget, content: { Color.background })
                    .padding(8)
            } else {
                GoldenRateWidgetEntryView(entry: entry)
                    .background(Color.background)
                    .padding(8)
            }
        }
        .configurationDisplayName("금니")
        .description("latestInterestRate")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
    }
}

private struct LatestRateTextView: View {
    
    let data: LatestInterestRateEntity
    
    var body: some View {
        Text(AttributedString(totalString: self.data.rateType.title, totalColor: .defaultGray, totalFont: .bold14, targetString: self.data.rateType.targetTitle, targetColor: self.data.rateType.color, targetFont: .bold14))
        Text(AttributedString(totalString: "\(self.data.changeSymbol()) \(String(format: "%.2f", self.data.currentRate))%", totalColor: .defaultText, totalFont: .bold14, targetString: self.data.changeSymbol(), targetColor: self.data.changeColor(), targetFont: .bold14))
    }
}

#Preview(as: .systemSmall) {
    GoldenRateWidget()
} timeline: {
    LatestInterestRateEntry(date: .now, entityList: LatestInterestRateEntity.mock)
}
