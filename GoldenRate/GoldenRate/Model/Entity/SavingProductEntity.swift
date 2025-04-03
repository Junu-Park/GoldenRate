//
//  SavingProductEntity.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

struct SavingProductEntity: Hashable {
    let id: String
    let name: String
    let companyID: String
    let companyName: String
    let joinWay: [String]
    let preferentialCondition: String
    let joinRestrict: JoinRestrictType
    let joinTarget: String
    let maxLimit: Int
    let interestRateType: [InterestRateType]
    let savingMethod: String
    let savingSimpleMonth: [Int]
    let savingSimpleRateList: [Int: [Double]]
    let savingCompoundMonth: [Int]
    let savingCompoundRateList: [Int: [Double]]
}
