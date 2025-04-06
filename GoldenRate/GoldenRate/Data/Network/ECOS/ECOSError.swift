//
//  ECOSError.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

enum ECOSErrorCode: String {
    case info100 = "INFO-100"
    case info200 = "INFO-200"
    case meta100 = "META-100"
    case meta200 = "META-200"
    case data100 = "DATA-100"
    case data200 = "DATA-200"
    case data300 = "DATA-300"
    case data301 = "DATA-301"
    case data400 = "DATA-400"
    case data500 = "DATA-500"
    case data600 = "DATA-600"
    case data601 = "DATA-601"
    case data602 = "DATA-602"
    
    var description: String {
        switch self {
        case .info100:
            return "인증키가 유효하지 않습니다"
        case .info200:
            return "일반 오류"
        case .meta100:
            return "통계표 메타정보 오류"
        case .meta200:
            return "통계항목 메타정보 오류"
        case .data100:
            return "통계표 코드 오류"
        case .data200:
            return "주기 오류"
        case .data300:
            return "검색시작/종료일자 오류"
        case .data301:
            return "검색시작일자 > 검색종료일자 오류"
        case .data400:
            return "통계항목 코드 오류"
        case .data500:
            return "응답 결과 형식 오류"
        case .data600:
            return "조회결과 건수 제한 오류"
        case .data601:
            return "조회결과 없음"
        case .data602:
            return "조회 결과 최대 건수 초과"
        }
    }
}

/// ECOS API 관련 오류를 정의하는 열거형
enum ECOSError: Error {
    case apiError(code: ECOSErrorCode, message: String)
    case unknownAPIError(code: String, message: String)
    
    var description: String {
        switch self {
        case .apiError(let code, let message):
            return "ECOS API 오류 [\(code.rawValue)]: \(message)"
        case .unknownAPIError(let code, let message):
            return "정의되지 않은 ECOS API 오류 [\(code)]: \(message)"
        }
    }
}
