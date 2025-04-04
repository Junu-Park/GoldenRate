//
//  APIConfig.swift
//  GoldenRate
//
//  Created by 박준우 on 4/3/25.
//

import Foundation

enum APIConfig {
    enum FSS {
        static var baseURL: String {
            return APIConfig.getValue(for: "FSS_BASE_URL")
        }
        
        static var apiKey: String {
            return APIConfig.getValue(for: "FSS_KEY")
        }
    }
    
    enum ECOS {
        static var baseURL: String {
            return APIConfig.getValue(for: "ECOS_BASE_URL")
        }
        
        static var apiKey: String {
            return APIConfig.getValue(for: "ECOS_KEY")
        }
    }
    
    private static func getValue(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            return ""
        }
        
        return value
    }
}
