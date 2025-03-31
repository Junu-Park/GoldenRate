//
//  SavingProductEntity.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

struct SavingProductEntity {
    let id: String
    let name: String
    let companyID: String
    let companyName: String
    let joinWay: [String]
    let preferentialCondition: String
    let joinTarget: String
    let note: String
    let rateMethod: String
    let savingMethod: String
    let savingAmountLimit: Int
    let savingMonth: [Int]
    let savingRateList: [Int: [Double]]
}
