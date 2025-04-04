//
//  ECOSErrorResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

struct ECOSErrorResponseDTO: Decodable {
    let result: ECOSErrorResult
    
    enum CodingKeys: String, CodingKey {
        case result = "RESULT"
    }
}

struct ECOSErrorResult: Decodable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}
