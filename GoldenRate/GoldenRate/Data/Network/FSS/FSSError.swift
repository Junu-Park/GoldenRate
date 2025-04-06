//
//  FSSError.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

enum FSSErrorCode: String {
    case success = "000"
    case unauthorizedKey = "010"
    case suspendedKey = "011"
    case deletedKey = "012"
    case expiredKey = "013"
    case dailyLimitExceeded = "020"
    case invalidIP = "021"
    case missingRequiredParam = "100"
    case invalidParamValue = "101"
    case unknownError = "900"
    
    var message: String {
        switch self {
        case .success:
            return "정상적으로 처리되는 경우"
        case .unauthorizedKey:
            return "등록되지 않은 인증키(auth)를 입력한 경우"
        case .suspendedKey:
            return "중지 처리된 인증키(auth)를 입력한 경우"
        case .deletedKey:
            return "삭제 처리된 인증키(auth)를 입력한 경우"
        case .expiredKey:
            return "샘플 인증키(auth)를 입력한 경우"
        case .dailyLimitExceeded:
            return "개인의 경우로, 일일허용횟수를 초과하여 사용한 경우"
        case .invalidIP:
            return "단체의 경우로, 인증키 신청시와 다른 IP를 사용한 경우"
        case .missingRequiredParam:
            return "요청변수값을 입력하지 않은 경우"
        case .invalidParamValue:
            return "부적절한 요청변수값을 사용한 경우"
        case .unknownError:
            return "Open API 서비스 내부 시스템 에러"
        }
    }
}

/// FSS API 관련 오류를 정의하는 열거형
enum FSSError: Error {
    case apiError(code: FSSErrorCode, message: String)
    case unknownAPIError(code: String, message: String)
    
    var description: String {
        switch self {
        case .apiError(let code, let message):
            return "FSS API 오류 [\(code.rawValue)]: \(message)"
        case .unknownAPIError(let code, let message):
            return "정의되지 않은 FSS API 오류 [\(code)]: \(message)"
        }
    }
}
