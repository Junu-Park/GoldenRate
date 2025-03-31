//
//  CompanyInfoResponseDTO.swift
//  GoldenRate
//
//  Created by 박준우 on 3/31/25.
//

import Foundation

struct CompanyInfoResponseDTO: Decodable {
    let result: CompanyInfoResult
}

struct CompanyInfoResult: Decodable {
    let prdt_div: String
    let total_count: Int
    let max_page_no: Int
    let now_page_no: Int
    let err_cd: String
    let err_msg: String
    let companyInfoList: [CompanyInfo]
    let optionList: [CompanyBranchInfo]
    
    enum CodingKeys: String, CodingKey {
        case prdt_div
        case total_count
        case max_page_no
        case now_page_no
        case err_cd
        case err_msg
        case companyInfoList = "baseList"
        case optionList
    }
}

struct CompanyInfo: Decodable {
    let dcls_month: String
    let companyCode: String
    let companyName: String
    let dcls_chrg_man: String
    let homp_url: String
    let cal_tel: String
    
    enum CodingKeys: String, CodingKey {
        case dcls_month
        case companyCode = "fin_co_no"
        case companyName = "kor_co_nm"
        case dcls_chrg_man
        case homp_url
        case cal_tel
    }
}

struct CompanyBranchInfo: Decodable {
    let dcls_month: String
    let fin_co_no: String
    let area_cd: String
    let area_nm: String
    let exis_yn: String
}
