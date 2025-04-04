//
//  FirstBankType.swift
//  GoldenRate
//
//  Created by 박준우 on 4/2/25.
//

import Foundation

enum FirstBankType: String, CaseIterable {
    case woori = "0010001"
    case standardChartered = "0010002"
    case im = "0010016"
    case busan = "0010017"
    case gwangju = "0010019"
    case jeju = "0010020"
    case jeonbuk = "0010022"
    case kyongnam = "0010024"
    case industrial = "0010026"
    case koreaDevelopment = "0010030"
    case kookmin = "0010927"
    case shinhan = "0011625"
    case nonghyup = "0013175"
    case hana = "0013909"
    case k = "0014674"
    case suhyup = "0014807"
    case kakao = "0015130"
    case toss = "0017801"
    
    var name: String {
            switch self {
            case .woori: return "우리은행"
            case .standardChartered: return "한국스탠다드차타드은행"
            case .im: return "아이엠뱅크"
            case .busan: return "부산은행"
            case .gwangju: return "광주은행"
            case .jeju: return "제주은행"
            case .jeonbuk: return "전북은행"
            case .kyongnam: return "경남은행"
            case .industrial: return "중소기업은행"
            case .koreaDevelopment: return "한국산업은행"
            case .kookmin: return "국민은행"
            case .shinhan: return "신한은행"
            case .nonghyup: return "농협은행주식회사"
            case .hana: return "하나은행"
            case .k: return "주식회사 케이뱅크"
            case .suhyup: return "수협은행"
            case .kakao: return "주식회사 카카오뱅크"
            case .toss: return "토스뱅크 주식회사"
            }
        }
}

