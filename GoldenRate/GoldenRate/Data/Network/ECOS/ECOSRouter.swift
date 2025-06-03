//
//  ECOSRouter.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

enum ECOSRouter: APIRouter {
    /// 1금융권 예금금리
    case bankDepositRate(startDate: String, endDate: String)
    /// 2금융권 예금금리
    case nonBankDepositRate(startDate: String, endDate: String)
    /// 한국은행 기준금리
    case baseRate(startDate: String, endDate: String)
    
    var baseURL: String {
        return APIConfig.ECOS.baseURL
    }
    
    var path: String {
        let apiKey = APIConfig.ECOS.apiKey
        
        switch self {
        case .bankDepositRate(let startDate, let endDate):
            return "/StatisticSearch/\(apiKey)/json/kr/9/12/121Y002/M/\(startDate)/\(endDate)/BEABAA21"
        case .nonBankDepositRate(let startDate, let endDate):
            return "/StatisticSearch/\(apiKey)/json/kr/9/12/121Y004/M/\(startDate)/\(endDate)/BEBBBE01"
        case .baseRate(let startDate, let endDate):
            return "/StatisticSearch/\(apiKey)/json/kr/9/12/722Y001/M/\(startDate)/\(endDate)/0101000"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        return nil // ECOS API는 쿼리 파라미터를 사용하지 않음
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 헤더 추가
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
