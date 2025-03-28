//
//  RateResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 3/28/25.
//

import Foundation

struct RateResponseDTO: Decodable {
    let statisticSearch: StatisticSearch
    
    enum CodingKeys: String, CodingKey {
        case statisticSearch = "StatisticSearch"
    }
}

struct StatisticSearch: Decodable {
    let list_total_count: Int
    let row: [StatisticSearchRow]
}
/// ex. TIME: "202503" / DATA_VALUE: "3"
struct StatisticSearchRow: Decodable {
    let STAT_CODE: String
    let STAT_NAME: String
    let ITEM_CODE1: String
    let ITEM_NAME1: String
    let ITEM_CODE2: String?
    let ITEM_NAME2: String?
    let ITEM_CODE3: String?
    let ITEM_NAME3: String?
    let ITEM_CODE4: String?
    let ITEM_NAME4: String?
    let UNIT_NAME: String
    let WGT: String?
    let TIME: String
    let DATA_VALUE: String
}
