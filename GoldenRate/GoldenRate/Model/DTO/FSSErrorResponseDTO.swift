//
//  FSSErrorResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

struct FSSErrorResponseDTO: Decodable {
    let result: FSSErrorResult
}

struct FSSErrorResult: Decodable {
    let code: String
    let message: String
    let totalCount: String
    
    enum CodingKeys: String, CodingKey {
        case code = "err_cd"
        case message = "err_msg"
        case totalCount = "total_count"
    }
}
