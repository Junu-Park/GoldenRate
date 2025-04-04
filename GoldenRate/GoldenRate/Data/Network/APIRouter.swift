//
//  APIRouter.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIRouter {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
    
    func asURLRequest() throws -> URLRequest
}
