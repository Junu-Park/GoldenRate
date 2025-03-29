//
//  HomeRepository.swift
//  GoldenRate
//
//  Created by 박준우 on 3/29/25.
//

import Foundation

protocol HomeRepository {
    func getRate(type: RateType) -> RateResponseDTO
}

struct MockHomeRepository: HomeRepository {
    
    func getRate(type: RateType) -> RateResponseDTO {
        switch type {
        case .base:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    list_total_count: 12,
                    row: [
                        StatisticSearchRow(
                            STAT_CODE: "722Y001",
                            STAT_NAME: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            ITEM_CODE1: "0101000",
                            ITEM_NAME1: "한국은행 기준금리",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202411",
                            DATA_VALUE: "3"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "722Y001",
                            STAT_NAME: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            ITEM_CODE1: "0101000",
                            ITEM_NAME1: "한국은행 기준금리",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202412",
                            DATA_VALUE: "3"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "722Y001",
                            STAT_NAME: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            ITEM_CODE1: "0101000",
                            ITEM_NAME1: "한국은행 기준금리",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202501",
                            DATA_VALUE: "3"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "722Y001",
                            STAT_NAME: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            ITEM_CODE1: "0101000",
                            ITEM_NAME1: "한국은행 기준금리",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202502",
                            DATA_VALUE: "2.75"
                        )
                    ]
                )
            )
        case .first:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    list_total_count: 12,
                    row: [
                        StatisticSearchRow(
                            STAT_CODE: "121Y002",
                            STAT_NAME: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEABAA2",
                            ITEM_NAME1: "저축성수신",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202411",
                            DATA_VALUE: "3.35"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y002",
                            STAT_NAME: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEABAA2",
                            ITEM_NAME1: "저축성수신",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202412",
                            DATA_VALUE: "3.21"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y002",
                            STAT_NAME: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEABAA2",
                            ITEM_NAME1: "저축성수신",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202501",
                            DATA_VALUE: "3.07"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y002",
                            STAT_NAME: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEABAA2",
                            ITEM_NAME1: "저축성수신",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연%",
                            WGT: nil,
                            TIME: "202502",
                            DATA_VALUE: "2.97"
                        )
                    ]
                )
            )
        case .second:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    list_total_count: 12,
                    row: [
                        StatisticSearchRow(
                            STAT_CODE: "121Y004",
                            STAT_NAME: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEBBBE01",
                            ITEM_NAME1: "상호저축은행-정기예금(1년)",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연리% ",
                            WGT: nil,
                            TIME: "202411",
                            DATA_VALUE: "3.61"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y004",
                            STAT_NAME: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEBBBE01",
                            ITEM_NAME1: "상호저축은행-정기예금(1년)",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연리% ",
                            WGT: nil,
                            TIME: "202412",
                            DATA_VALUE: "3.44"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y004",
                            STAT_NAME: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEBBBE01",
                            ITEM_NAME1: "상호저축은행-정기예금(1년)",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연리% ",
                            WGT: nil,
                            TIME: "202501",
                            DATA_VALUE: "3.3"
                        ),
                        StatisticSearchRow(
                            STAT_CODE: "121Y004",
                            STAT_NAME: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            ITEM_CODE1: "BEBBBE01",
                            ITEM_NAME1: "상호저축은행-정기예금(1년)",
                            ITEM_CODE2: nil,
                            ITEM_NAME2: nil,
                            ITEM_CODE3: nil,
                            ITEM_NAME3: nil,
                            ITEM_CODE4: nil,
                            ITEM_NAME4: nil,
                            UNIT_NAME: "연리% ",
                            WGT: nil,
                            TIME: "202502",
                            DATA_VALUE: "3.1"
                        )
                    ]
                )
            )
        }
    }
}
