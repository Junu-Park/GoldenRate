//
//  FSSRouter.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

enum FSSRouter: APIRouter {
    case depositProducts(topFinGrpNo: String, pageNo: Int, financeCd: String? = nil)
    case savingProducts(topFinGrpNo: String, pageNo: Int, financeCd: String? = nil)
    
    var baseURL: String {
        return APIConfig.FSS.baseURL
    }
    
    var path: String {
        switch self {
        case .depositProducts:
            return "/depositProductsSearch.json"
        case .savingProducts:
            return "/savingProductsSearch.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [String: String]? {
        var params: [String: String] = [
            "auth": APIConfig.FSS.apiKey
        ]
        
        switch self {
        case .depositProducts(let topFinGrpNo, let pageNo, let financeCd):
            params["topFinGrpNo"] = topFinGrpNo
            params["pageNo"] = String(pageNo)
            if let financeCd = financeCd, !financeCd.isEmpty {
                params["financeCd"] = financeCd
            }
        case .savingProducts(let topFinGrpNo, let pageNo, let financeCd):
            params["topFinGrpNo"] = topFinGrpNo
            params["pageNo"] = String(pageNo)
            if let financeCd = financeCd, !financeCd.isEmpty {
                params["financeCd"] = financeCd
            }
        }
        
        return params
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        // 쿼리 파라미터 추가
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
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
