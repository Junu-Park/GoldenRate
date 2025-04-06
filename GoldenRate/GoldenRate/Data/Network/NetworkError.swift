//
//  NetworkError.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    case noData
    case fssError(FSSError)
    case ecosError(ECOSError)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL"
        case .invalidResponse:
            return "유효하지 않은 응답"
        case .requestFailed(let error):
            return "요청 실패: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "디코딩 실패: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "서버 오류 (상태 코드: \(statusCode))"
        case .noData:
            return "데이터가 없습니다."
        case .fssError(let error):
            return error.description
        case .ecosError(let error):
            return error.description
        }
    }
}
