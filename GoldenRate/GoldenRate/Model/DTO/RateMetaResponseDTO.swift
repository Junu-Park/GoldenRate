//
//  RateMetaResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 3/28/25.
//

import Foundation

struct RateMetaResponseDTO: Decodable {
    var StatisticItemList: [StatisticItem]
}

struct StatisticItem: Decodable {
    var list_total_count: Int
    var row: [StatisticItemRow]
}
/// ex. START_TIME: "199905" / END_TIME: "202502"
struct StatisticItemRow: Decodable {
    let STAT_CODE: String
    let STAT_NAME: String
    let GRP_CODE: String
    let GRP_NAME: String
    let ITEM_CODE: String
    let ITEM_NAME: String
    let P_ITEM_CODE: String?
    let P_ITEM_NAME: String?
    let CYCLE: String
    let START_TIME: String
    let END_TIME: String
    let DATA_CNT: Int
    let UNIT_NAME: String
    let WEIGHT: String?
}
