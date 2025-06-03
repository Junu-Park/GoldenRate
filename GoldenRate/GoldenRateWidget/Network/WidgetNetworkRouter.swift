//
//  WidgetNetworkRouter.swift
//  GoldenRateWidgetExtension
//
//  Created by 박준우 on 4/21/25.
//

import Foundation

enum WidgetNetworkRouter: APIRouter {
    /// 1금융권 예금금리
    case firstBankRate
    /// 2금융권 예금금리
    case secondBankRate
    /// 한국은행 기준금리
    case baseRate
    
    var baseURL: String {
        return APIConfig.ECOS.baseURL
    }
    
    var path: String {
        let apiKey = APIConfig.ECOS.apiKey
        let date = self.getDateString()
        let yearAgoDate = self.getOneYearAgoDateString()
        
        switch self {
        case .firstBankRate:
            return "/StatisticSearch/\(apiKey)/json/kr/1/12/121Y002/M/\(yearAgoDate)/\(date)/BEABAA21"
        case .secondBankRate:
            return "/StatisticSearch/\(apiKey)/json/kr/1/12/121Y004/M/\(yearAgoDate)/\(date)/BEBBBE01"
        case .baseRate:
            return "/StatisticSearch/\(apiKey)/json/kr/1/12/722Y001/M/\(yearAgoDate)/\(date)/0101000"
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
    
    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: .now)
    }
    
    private func getOneYearAgoDateString() -> String {
        let oneYearAgoCalendar = Calendar.current.date(byAdding: .year, value: -1, to: .now) ?? .now
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        return formatter.string(from: oneYearAgoCalendar)
    }
}
