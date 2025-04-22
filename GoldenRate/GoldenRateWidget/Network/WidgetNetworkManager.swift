//
//  WidgetNetworkManager.swift
//  GoldenRateWidgetExtension
//
//  Created by 박준우 on 4/21/25.
//

import Foundation

final class WidgetNetworkManager {
    static let shared = WidgetNetworkManager()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        self.session = URLSession(configuration: configuration)
    }
    
    func requestRateDataList() async throws -> [RateResponseDTO] {
        do {
            let baseRequest = try WidgetNetworkRouter.baseRate.asURLRequest()
            let firstRequest = try WidgetNetworkRouter.firstBankRate.asURLRequest()
            let secondRequest = try WidgetNetworkRouter.secondBankRate.asURLRequest()
            
            async let (baseData, baseResponse) = try await session.data(for: baseRequest)
            async let (firstData, firstResponse) = try await session.data(for: firstRequest)
            async let (secondData, secondResponse) = try await session.data(for: secondRequest)
            
            guard let bR = try await baseResponse as? HTTPURLResponse,
                  let fR = try await firstResponse as? HTTPURLResponse,
                  let sR = try await secondResponse as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if let failedStatusCode = [bR.statusCode, fR.statusCode, sR.statusCode].first(where: { !(200...299).contains($0) }) {
                throw NetworkError.serverError(statusCode: failedStatusCode)
            }
            
            let bD = try await baseData
            let fD = try await firstData
            let sD = try await secondData
            
            guard !bD.isEmpty, !fD.isEmpty, !sD.isEmpty else {
                throw NetworkError.noData
            }
            
            let decoder = JSONDecoder()
            let decodedDataList = try [
                    decoder.decode(RateResponseDTO.self, from: bD),
                    decoder.decode(RateResponseDTO.self, from: fD),
                    decoder.decode(RateResponseDTO.self, from: sD)
                ]
            
            return decodedDataList
        } catch {
            throw error
        }
    }
}
