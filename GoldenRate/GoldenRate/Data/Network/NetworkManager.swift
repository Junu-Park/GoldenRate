//
//  NetworkManager.swift
//  GoldenRate
//
//  Created by 박준우 on 4/6/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(router: APIRouter) async throws -> T {
        do {
            let request = try router.asURLRequest()
            
            // 네트워크 요청 수행
            let (data, response) = try await session.data(for: request)
            
            // 응답 상태 코드 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 성공적인 응답인지 확인 (200-299 상태 코드)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 데이터가 있는지 확인
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // JSON 디코딩
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    // MARK: - FSS API Methods
    
    /// FSS API 응답을 처리하고 오류가 있는지 확인합니다.
    /// - Parameter data: API 응답 데이터
    /// - Throws: 오류가 있는 경우 FSSError를 throw 합니다.
    private func checkFSSError(data: Data) throws {
        do {
            let errorResponse = try JSONDecoder().decode(FSSErrorResponseDTO.self, from: data)
            let errorCode = errorResponse.result.code
            let errorMessage = errorResponse.result.message
            
            // 정상이 아닌 경우에만 오류로 처리
            if errorCode != FSSErrorCode.success.rawValue {
                if let fssErrorCode = FSSErrorCode(rawValue: errorCode) {
                    throw NetworkError.fssError(.apiError(code: fssErrorCode, message: errorMessage))
                } else {
                    throw NetworkError.fssError(.unknownAPIError(code: errorCode, message: errorMessage))
                }
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            // 오류 응답 형식이 아닌 경우는 정상 데이터로 간주하고 넘어감
            return
        }
    }
    
    /// FSS API 요청을 수행하는 특화된 메서드
    /// - Parameter router: API 라우터
    /// - Returns: 디코딩된 데이터
    func requestFSS<T: Decodable>(router: APIRouter) async throws -> T {
        do {
            let request = try router.asURLRequest()
            
            // 네트워크 요청 수행
            let (data, response) = try await session.data(for: request)
            
            // 응답 상태 코드 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 성공적인 응답인지 확인 (200-299 상태 코드)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 데이터가 있는지 확인
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // FSS API 오류 확인
            try checkFSSError(data: data)
            
            // JSON 디코딩
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    /// 예금상품 정보 조회
    /// - Parameters:
    ///   - topFinGrpNo: 회사 코드
    ///   - pageNo: 페이지 번호 (최소값: 1)
    ///   - financeCd: 검색어 (옵션)
    /// - Returns: 디코딩된 예금상품 정보
    func fetchDepositProducts<T: Decodable>(
        topFinGrpNo: String,
        pageNo: Int = 1,
        financeCd: String? = nil
    ) async throws -> T {
        let router = FSSRouter.depositProducts(
            topFinGrpNo: topFinGrpNo,
            pageNo: max(1, pageNo),
            financeCd: financeCd
        )
        return try await requestFSS(router: router)
    }
    
    /// 모든 예금상품 정보 조회
    /// - Parameters:
    ///   - topFinGrpNo: 회사 코드
    ///   - financeCd: 검색어 (옵션)
    /// - Returns: 디코딩된 예금상품 정보
    func fetchAllDepositProducts(
        topFinGrpNo: String,
        financeCd: String? = nil
    ) async throws -> DepositProductResponseDTO {
        // 1. 첫 페이지를 가져와서 총 페이지 수를 확인
        let firstPageResponse: DepositProductResponseDTO = try await fetchDepositProducts(
            topFinGrpNo: topFinGrpNo,
            pageNo: 1,
            financeCd: financeCd
        )
        
        // 만약 페이지가 1개만 있다면 바로 반환
        if firstPageResponse.result.max_page_no <= 1 {
            return firstPageResponse
        }
        
        // 2. 나머지 페이지 데이터를 가져오기
        var allProducts = firstPageResponse.result.depositProductInfoList
        var allRates = firstPageResponse.result.depositProductRateInfoList
        
        // 2페이지부터 마지막 페이지까지 순차적으로 가져오기
        for pageNo in 2...firstPageResponse.result.max_page_no {
            let pageResponse: DepositProductResponseDTO = try await fetchDepositProducts(
                topFinGrpNo: topFinGrpNo,
                pageNo: pageNo,
                financeCd: financeCd
            )
            
            // 상품 정보와 금리 정보 병합
            allProducts.append(contentsOf: pageResponse.result.depositProductInfoList)
            allRates.append(contentsOf: pageResponse.result.depositProductRateInfoList)
        }
        
        // 3. 모든 데이터가 포함된 새로운 DTO 생성
        let combinedResult = DepositProductResult(
            prdt_div: firstPageResponse.result.prdt_div,
            total_count: firstPageResponse.result.total_count,
            max_page_no: firstPageResponse.result.max_page_no,
            now_page_no: 1, // 통합된 결과이므로 페이지 번호는 1로 설정
            err_cd: firstPageResponse.result.err_cd,
            err_msg: firstPageResponse.result.err_msg,
            depositProductInfoList: allProducts,
            depositProductRateInfoList: allRates
        )
        
        return DepositProductResponseDTO(result: combinedResult)
    }
    
    /// 적금상품 정보 조회
    /// - Parameters:
    ///   - topFinGrpNo: 회사 코드
    ///   - pageNo: 페이지 번호 (최소값: 1)
    ///   - financeCd: 검색어 (옵션)
    /// - Returns: 디코딩된 적금상품 정보
    func fetchSavingProducts<T: Decodable>(
        topFinGrpNo: String,
        pageNo: Int = 1,
        financeCd: String? = nil
    ) async throws -> T {
        let router = FSSRouter.savingProducts(
            topFinGrpNo: topFinGrpNo,
            pageNo: max(1, pageNo),
            financeCd: financeCd
        )
        return try await requestFSS(router: router)
    }
    
    /// 모든 적금상품 정보 조회
    /// - **Parameters**:
    ///   - topFinGrpNo: 회사 코드
    ///   - financeCd: 검색어 (옵션)
    /// - **Returns**: 모든 페이지의 적금상품 정보를 취합한 결과
    func fetchAllSavingProducts(
        topFinGrpNo: String,
        financeCd: String? = nil
    ) async throws -> SavingProductResponseDTO {
        // 1. 첫 페이지를 가져와서 총 페이지 수를 확인
        let firstPageResponse: SavingProductResponseDTO = try await fetchSavingProducts(
            topFinGrpNo: topFinGrpNo,
            pageNo: 1,
            financeCd: financeCd
        )
        
        // 만약 페이지가 1개만 있다면 바로 반환
        if firstPageResponse.result.max_page_no <= 1 {
            return firstPageResponse
        }
        
        // 2. 나머지 페이지 데이터를 가져오기
        var allProducts = firstPageResponse.result.savingProductInfoList
        var allRates = firstPageResponse.result.savingProductRateInfoList
        
        // 2페이지부터 마지막 페이지까지 순차적으로 가져오기
        for pageNo in 2...firstPageResponse.result.max_page_no {
            let pageResponse: SavingProductResponseDTO = try await fetchSavingProducts(
                topFinGrpNo: topFinGrpNo,
                pageNo: pageNo,
                financeCd: financeCd
            )
            
            // 상품 정보와 금리 정보 병합
            allProducts.append(contentsOf: pageResponse.result.savingProductInfoList)
            allRates.append(contentsOf: pageResponse.result.savingProductRateInfoList)
        }
        
        // 3. 모든 데이터가 포함된 새로운 DTO 생성
        let combinedResult = SavingProductResult(
            prdt_div: firstPageResponse.result.prdt_div,
            total_count: firstPageResponse.result.total_count,
            max_page_no: firstPageResponse.result.max_page_no,
            now_page_no: 1, // 통합된 결과이므로 페이지 번호는 1로 설정
            err_cd: firstPageResponse.result.err_cd,
            err_msg: firstPageResponse.result.err_msg,
            savingProductInfoList: allProducts,
            savingProductRateInfoList: allRates
        )
        
        return SavingProductResponseDTO(result: combinedResult)
    }
    
    // MARK: - ECOS API Methods
    
    /// ECOS API 응답을 처리하고 오류가 있는지 확인합니다.
    /// - Parameter data: API 응답 데이터
    /// - Throws: 오류가 있는 경우 ECOSError를 throw 합니다.
    private func checkECOSError(data: Data) throws {
        do {
            let errorResponse = try JSONDecoder().decode(ECOSErrorResponseDTO.self, from: data)
            let errorCode = errorResponse.result.code
            let errorMessage = errorResponse.result.message
            
            // 오류 코드가 있는 경우
            if let ecosErrorCode = ECOSErrorCode(rawValue: errorCode) {
                throw NetworkError.ecosError(.apiError(code: ecosErrorCode, message: errorMessage))
            } else {
                throw NetworkError.ecosError(.unknownAPIError(code: errorCode, message: errorMessage))
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            // 오류 응답 형식이 아닌 경우는 정상 데이터로 간주하고 넘어감
            return
        }
    }
    
    /// ECOS API 요청을 수행하는 특화된 메서드
    /// - Parameter router: API 라우터
    /// - Returns: 디코딩된 데이터
    func requestECOS<T: Decodable>(router: APIRouter) async throws -> T {
        do {
            let request = try router.asURLRequest()
            // 네트워크 요청 수행
            let (data, response) = try await session.data(for: request)
            
            // 응답 상태 코드 확인
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // 성공적인 응답인지 확인 (200-299 상태 코드)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 데이터가 있는지 확인
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            // ECOS API 오류 확인
            try checkECOSError(data: data)
            
            // JSON 디코딩
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    /// 1금융권 예금금리 조회
    /// - Parameters:
    ///   - startDate: 시작 날짜 (yyyyMM 형식, 기본값: 1년 전)
    ///   - endDate: 종료 날짜 (yyyyMM 형식, 기본값: 현재 달)
    /// - Returns: 디코딩된 1금융권 예금금리 정보
    func fetchFirstInterestRate<T: Decodable>(
        startDate: String? = nil,
        endDate: String? = nil
    ) async throws -> T {
        let start = startDate ?? Date().convertTo1YearAgoString(format: .yyyyMM)
        let end = endDate ?? Date().convertToString(format: .yyyyMM)
        
        let router = ECOSRouter.bankDepositRate(startDate: start, endDate: end)
        return try await requestECOS(router: router)
    }
    
    /// 2금융권 예금금리 조회
    /// - Parameters:
    ///   - startDate: 시작 날짜 (yyyyMM 형식, 기본값: 1년 전)
    ///   - endDate: 종료 날짜 (yyyyMM 형식, 기본값: 현재 달)
    /// - Returns: 디코딩된 2금융권 예금금리 정보
    func fetchSecondInterestRate<T: Decodable>(
        startDate: String? = nil,
        endDate: String? = nil
    ) async throws -> T {
        let start = startDate ?? Date().convertTo1YearAgoString(format: .yyyyMM)
        let end = endDate ?? Date().convertToString(format: .yyyyMM)
        
        let router = ECOSRouter.nonBankDepositRate(startDate: start, endDate: end)
        return try await requestECOS(router: router)
    }
    
    /// 한국은행 기준금리 조회
    /// - Parameters:
    ///   - startDate: 시작 날짜 (yyyyMM 형식, 기본값: 1년 전)
    ///   - endDate: 종료 날짜 (yyyyMM 형식, 기본값: 현재 달)
    /// - Returns: 디코딩된 한국은행 기준금리 정보
    func fetchBaseRate<T: Decodable>(
        startDate: String? = nil,
        endDate: String? = nil
    ) async throws -> T {
        let start = startDate ?? Date().convertTo1YearAgoString(format: .yyyyMM)
        let end = endDate ?? Date().convertToString(format: .yyyyMM)
        
        let router = ECOSRouter.baseRate(startDate: start, endDate: end)
        return try await requestECOS(router: router)
    }
}
