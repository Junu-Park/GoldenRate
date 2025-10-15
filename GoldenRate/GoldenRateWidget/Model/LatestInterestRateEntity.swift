//
//  LatestInterestRateEntity.swift
//  GoldenRate
//
//  Created by 박준우 on 4/20/25.
//

import SwiftUI

struct LatestInterestRateEntity: Identifiable {
    let id: UUID = UUID()
    let rateType: LatestRateType
    let previousRate: Double
    let currentRate: Double
    
    /// 이전 금리에서 현재 금리 변화상태
    ///  -1: 하락, 0: 변화 없음. 1: 상승
    private func changeState() -> Int {
        switch (self.currentRate - self.previousRate) {
        case ..<0:
            return -1
        case 0:
            return 0
        default:
            return 1
        }
    }
    
    func changeColor() -> Color {
        switch self.changeState() {
        case -1:
            return .blue
        case 1:
            return .red
        default:
            return .defaultGray
        }
    }
    
    func changeSymbol() -> String {
        switch self.changeState() {
        case -1:
            return "▼"
        case 1:
            return "▲"
        default:
            return "＝"
        }
    }
    
    static let mock: [LatestInterestRateEntity] = [
        LatestInterestRateEntity(rateType: .base, previousRate: 2.75, currentRate: 2.75),
        LatestInterestRateEntity(rateType: .first, previousRate: 2.84, currentRate: 2.98),
        LatestInterestRateEntity(rateType: .second, previousRate: 3.30, currentRate: 3.10)
    ]
}
