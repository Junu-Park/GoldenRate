//
//  DepositProductResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

struct DepositProductResponseDTO: Decodable {
    let result: DepositProductResult
    
    func convertToEntityArray() -> [DepositProductEntity] {
        let rateInfoList = self.result.depositProductRateInfoList
        
        return self.result.depositProductInfoList.map { info in
            return DepositProductEntity(
                id: info.productCode,
                name: info.productName,
                companyID: info.companyCode,
                companyName: info.companyName,
                joinWay: info.join_way?.split(separator: ",").map { String($0) } ?? [],
                preferentialCondition: info.preferentialCondition,
                joinRestrict: JoinRestrictType.init(rawValue: Int(info.joinRestrict) ?? 0) ?? .noRestrict,
                joinTarget: info.joinTarget,
                maxLimit: info.max_limit ?? 0,
                interestRateType: {
                    let isSimple = rateInfoList.first(where: { $0.productCode == info.productCode && $0.rateMethod == InterestRateType.simple.rawValue }) != nil
                    let isCompound = rateInfoList.first(where: { $0.productCode == info.productCode && $0.rateMethod == InterestRateType.compound.rawValue }) != nil
                    
                    var interestRateType: [InterestRateType] = []
                    
                    if isSimple {
                        interestRateType.append(.simple)
                    }
                    
                    if isCompound {
                        interestRateType.append(.compound)
                    }
                    
                    return interestRateType
                }(),
                depositSimpleMonth: rateInfoList.filter({ $0.productCode == info.productCode && $0.rateMethod == InterestRateType.simple.rawValue }).map { Int($0.depositMonth) ?? 0 },
                depositSimpleRateList: rateInfoList.filter({ $0.productCode == info.productCode && $0.rateMethod == InterestRateType.simple.rawValue}).reduce(into: [:]) { result, info in
                    result[Int(info.depositMonth)!] = [info.baseRate ?? 0.0, info.highestRate ?? 0.0] },
                depositCompoundMonth: rateInfoList.filter({ $0.productCode == info.productCode && $0.rateMethod == InterestRateType.compound.rawValue }).map { Int($0.depositMonth) ?? 0 },
                depositCompoundRateList: rateInfoList.filter({ $0.productCode == info.productCode && $0.rateMethod == InterestRateType.compound.rawValue}).reduce(into: [:]) { result, info in
                    result[Int(info.depositMonth)!] = [info.baseRate ?? 0.0, info.highestRate ?? 0.0] }
            )
        }
    }
}

struct DepositProductResult: Decodable {
    let prdt_div: String
    let total_count: Int
    let max_page_no: Int
    let now_page_no: Int
    let err_cd: String
    let err_msg: String
    let depositProductInfoList: [DepositProductInfo]
    let depositProductRateInfoList: [DepositProductRateInfo]
    
    enum CodingKeys: String, CodingKey {
        case prdt_div
        case total_count
        case max_page_no
        case now_page_no
        case err_cd
        case err_msg
        case depositProductInfoList = "baseList"
        case depositProductRateInfoList = "optionList"
    }
}

struct DepositProductInfo: Decodable {
    let dcls_month: String
    let companyCode: String
    let productCode: String
    let companyName: String
    let productName: String
    let join_way: String?
    let mtrt_int: String
    let preferentialCondition: String
    let joinRestrict: String
    let joinTarget: String
    let etc_note: String
    let max_limit: Int?
    let dcls_strt_day: String
    let dcls_end_day: String?
    let fin_co_subm_day: String
    
    enum CodingKeys: String, CodingKey {
        case dcls_month
        case companyCode = "fin_co_no"
        case productCode = "fin_prdt_cd"
        case companyName = "kor_co_nm"
        case productName = "fin_prdt_nm"
        case join_way
        case mtrt_int
        case preferentialCondition = "spcl_cnd"
        case joinRestrict = "join_deny"
        case joinTarget = "join_member"
        case etc_note
        case max_limit
        case dcls_strt_day
        case dcls_end_day
        case fin_co_subm_day
    }
}

struct DepositProductRateInfo: Decodable {
    let dcls_month: String
    let companyCode: String
    let productCode: String
    let intr_rate_type: String
    let rateMethod: String
    let depositMonth: String
    let baseRate: Double?
    let highestRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case dcls_month
        case companyCode = "fin_co_no"
        case productCode = "fin_prdt_cd"
        case intr_rate_type
        case rateMethod = "intr_rate_type_nm"
        case depositMonth = "save_trm"
        case baseRate = "intr_rate"
        case highestRate = "intr_rate2"
    }
}
