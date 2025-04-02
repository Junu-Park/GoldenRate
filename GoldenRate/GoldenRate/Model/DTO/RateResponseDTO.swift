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
    let listTotalCount: Int
    let row: [StatisticSearchRow]
    
    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case row
    }
}

struct StatisticSearchRow: Decodable {
    let statCode: String
    let statName: String
    let itemCode1: String
    let itemName1: String
    let itemCode2: String?
    let itemName2: String?
    let itemCode3: String?
    let itemName3: String?
    let itemCode4: String?
    let itemName4: String?
    let unitName: String
    let wgt: String?
    let time: String
    let dataValue: String
    
    enum CodingKeys: String, CodingKey {
        case statCode = "STAT_CODE"
        case statName = "STAT_NAME"
        case itemCode1 = "ITEM_CODE1"
        case itemName1 = "ITEM_NAME1"
        case itemCode2 = "ITEM_CODE2"
        case itemName2 = "ITEM_NAME2"
        case itemCode3 = "ITEM_CODE3"
        case itemName3 = "ITEM_NAME3"
        case itemCode4 = "ITEM_CODE4"
        case itemName4 = "ITEM_NAME4"
        case unitName = "UNIT_NAME"
        case wgt = "WGT"
        case time = "TIME"
        case dataValue = "DATA_VALUE"
    }
}
