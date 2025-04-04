//
//  HomeRepository.swift
//  GoldenRate
//
//  Created by 박준우 on 3/29/25.
//

import Foundation

protocol HomeRepository {
    func getRate(type: RateType) async throws -> RateResponseDTO
//    func getFinancialCompany(type: FinancialCompanyType) -> FinancialCompanyResponseDTO
    func getDepositProduct(type: FinancialCompanyType) async throws -> DepositProductResponseDTO
    func getSavingProduct(type: FinancialCompanyType) async throws -> SavingProductResponseDTO
}

struct RealHomeRepository: HomeRepository {
    func getRate(type: RateType) async throws -> RateResponseDTO {
        do {
            switch type {
            case .base:
                return try await NetworkManager.shared.fetchBaseRate()
            case .first:
                return try await NetworkManager.shared.fetchFirstInterestRate()
            case .second:
                return try await NetworkManager.shared.fetchSecondInterestRate()
            }
        } catch {
            throw error
        }
    }
    
    func getDepositProduct(type: FinancialCompanyType) async throws -> DepositProductResponseDTO {
        do {
            switch type {
            case .all:
                let first: DepositProductResponseDTO = try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
                let second: DepositProductResponseDTO = try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
                
                var totalInfoList = first.result.depositProductInfoList
                totalInfoList.append(contentsOf: second.result.depositProductInfoList)
                var totalRateList = first.result.depositProductRateInfoList
                totalRateList.append(contentsOf: second.result.depositProductRateInfoList)
                
                return DepositProductResponseDTO(result: DepositProductResult(prdt_div: first.result.prdt_div, total_count: first.result.total_count + second.result.total_count, max_page_no: 1, now_page_no: 1, err_cd: first.result.err_cd, err_msg: first.result.err_msg, depositProductInfoList: totalInfoList, depositProductRateInfoList: totalRateList))
            case .firstBank:
                return try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
            case .secondBank:
                return try await NetworkManager.shared.fetchAllDepositProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
            }
        } catch {
            throw error
        }
    }
    
    func getSavingProduct(type: FinancialCompanyType) async throws -> SavingProductResponseDTO {
        do {
            switch type {
            case .all:
                let first: SavingProductResponseDTO = try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
                let second: SavingProductResponseDTO = try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
                
                var totalInfoList = first.result.savingProductInfoList
                totalInfoList.append(contentsOf: second.result.savingProductInfoList)
                var totalRateList = first.result.savingProductRateInfoList
                totalRateList.append(contentsOf: second.result.savingProductRateInfoList)
                
                return SavingProductResponseDTO(result: SavingProductResult(prdt_div: first.result.prdt_div, total_count: first.result.total_count + second.result.total_count, max_page_no: 1, now_page_no: 1, err_cd: first.result.err_cd, err_msg: first.result.err_msg, savingProductInfoList: totalInfoList, savingProductRateInfoList: totalRateList))
            case .firstBank:
                return try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.firstBank.code)
            case .secondBank:
                return try await NetworkManager.shared.fetchAllSavingProducts(topFinGrpNo: FinancialCompanyType.secondBank.code)
            }
        } catch {
            throw error
        }
    }
}

struct MockHomeRepository: HomeRepository {
    
    func getRate(type: RateType) -> RateResponseDTO {
        switch type {
        case .base:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    listTotalCount: 12,
                    row: [
                        StatisticSearchRow(
                            statCode: "722Y001",
                            statName: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            itemCode1: "0101000",
                            itemName1: "한국은행 기준금리",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202411",
                            dataValue: "3"
                        ),
                        StatisticSearchRow(
                            statCode: "722Y001",
                            statName: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            itemCode1: "0101000",
                            itemName1: "한국은행 기준금리",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202412",
                            dataValue: "3"
                        ),
                        StatisticSearchRow(
                            statCode: "722Y001",
                            statName: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            itemCode1: "0101000",
                            itemName1: "한국은행 기준금리",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202501",
                            dataValue: "3"
                        ),
                        StatisticSearchRow(
                            statCode: "722Y001",
                            statName: "1.3.1. 한국은행 기준금리 및 여수신금리",
                            itemCode1: "0101000",
                            itemName1: "한국은행 기준금리",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202502",
                            dataValue: "2.75"
                        )
                    ]
                )
            )
        case .first:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    listTotalCount: 12,
                    row: [
                        StatisticSearchRow(
                            statCode: "121Y002",
                            statName: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            itemCode1: "BEABAA2",
                            itemName1: "저축성수신",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202411",
                            dataValue: "3.35"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y002",
                            statName: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            itemCode1: "BEABAA2",
                            itemName1: "저축성수신",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202412",
                            dataValue: "3.21"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y002",
                            statName: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            itemCode1: "BEABAA2",
                            itemName1: "저축성수신",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202501",
                            dataValue: "3.07"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y002",
                            statName: "1.3.3.1.1. 예금은행 수신금리(신규취급액 기준)",
                            itemCode1: "BEABAA2",
                            itemName1: "저축성수신",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연%",
                            wgt: nil,
                            time: "202502",
                            dataValue: "2.97"
                        )
                    ]
                )
            )
        case .second:
            return RateResponseDTO(
                statisticSearch: StatisticSearch(
                    listTotalCount: 12,
                    row: [
                        StatisticSearchRow(
                            statCode: "121Y004",
                            statName: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            itemCode1: "BEBBBE01",
                            itemName1: "상호저축은행-정기예금(1년)",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연리% ",
                            wgt: nil,
                            time: "202411",
                            dataValue: "3.61"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y004",
                            statName: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            itemCode1: "BEBBBE01",
                            itemName1: "상호저축은행-정기예금(1년)",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연리% ",
                            wgt: nil,
                            time: "202412",
                            dataValue: "3.44"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y004",
                            statName: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            itemCode1: "BEBBBE01",
                            itemName1: "상호저축은행-정기예금(1년)",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연리% ",
                            wgt: nil,
                            time: "202501",
                            dataValue: "3.3"
                        ),
                        StatisticSearchRow(
                            statCode: "121Y004",
                            statName: "1.3.4.1. 비은행금융기관 수신금리(신규취급액 기준)",
                            itemCode1: "BEBBBE01",
                            itemName1: "상호저축은행-정기예금(1년)",
                            itemCode2: nil,
                            itemName2: nil,
                            itemCode3: nil,
                            itemName3: nil,
                            itemCode4: nil,
                            itemName4: nil,
                            unitName: "연리% ",
                            wgt: nil,
                            time: "202502",
                            dataValue: "3.1"
                        )
                    ]
                )
            )
        }
    }
    /*
    func getFinancialCompany(type: FinancialCompanyType) -> FinancialCompanyResponseDTO {
        switch type {
        case .firstBank:
            return FinancialCompanyResponseDTO(
                result: FinancialCompanyResult(
                    prdt_div: "F",
                    total_count: 18,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    financialCompanyInfoList: [
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            companyName: "우리은행",
                            dcls_chrg_man: "개인금융솔루션부, 1588-5000\n부동산금융부,  1588-5000",
                            homp_url: "https://spot.wooribank.com/pot/Dream?withyou=po",
                            cal_tel: "15885000"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            companyName: "한국스탠다드차타드은행",
                            dcls_chrg_man: "SC제일은행 고객센터\n1588-1599",
                            homp_url: "http://www.standardchartered.co.kr",
                            cal_tel: "15881599"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010016",
                            companyName: "아이엠뱅크",
                            dcls_chrg_man: "개인여신팀, 053-740-2378                            수신기획부, 053-740-2162",
                            homp_url: "http://www.imbank.co.kr",
                            cal_tel: "15885050"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010017",
                            companyName: "부산은행",
                            dcls_chrg_man: "(예금)수신고객부, 051-620-3339\n(대출)여신고객부, 051-620-3423\n실제 상담은 인근 영업점이나 당행 콜센터(1588-6200)로 문의",
                            homp_url: "http://www.busanbank.co.kr",
                            cal_tel: "15886200"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010019",
                            companyName: "광주은행",
                            dcls_chrg_man: "영업추진부 수신지원팀 062-239-5206          여신지원팀 062-239-6509\n카드사업부 062-239-6107\n*실제 상담은 인근영업점이나 당행 콜센터(1588-3388)로 문의",
                            homp_url: "http://www.kjbank.com",
                            cal_tel: "15883388"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010020",
                            companyName: "제주은행",
                            dcls_chrg_man: "상품솔루션부, 064-720-0166",
                            homp_url: "https://www.jejubank.co.kr/hmpg/main.do",
                            cal_tel: "15880079"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010022",
                            companyName: "전북은행",
                            dcls_chrg_man: "수신추진부,\n063-250-7469\n여신기획부,\n063-250-7370\n* 실제 상담은 인근 영업점이나 당행 콜센터(1588-4477)로 문의",
                            homp_url: "https://www.jbbank.co.kr/EFINANCE_MAIN.act",
                            cal_tel: "15884477"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010024",
                            companyName: "경남은행",
                            dcls_chrg_man: "비대면고객부(대출문의),055-290-8743\n개인고객부(예·적금상품),1600-8585",
                            homp_url: "https://www.knbank.co.kr/ib20/mnu/FPMDPT020000000",
                            cal_tel: "16008585"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010026",
                            companyName: "중소기업은행",
                            dcls_chrg_man: "고객 문의 1566-2566",
                            homp_url: "http://www.ibk.co.kr",
                            cal_tel: "15662566"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010030",
                            companyName: "한국산업은행",
                            dcls_chrg_man: "(예금)수신기획부, 02-787-7439\n(개인대출)지역성장지원실, 051-640-3372\n(기업대출)영업기획부, 02-787-6929",
                            homp_url: "https://www.kdb.co.kr",
                            cal_tel: "0215881500"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010927",
                            companyName: "국민은행",
                            dcls_chrg_man: "(예금)수신상품부(P), 02-1588-9999\n(대출)개인여신부(P), 02-1588-9999",
                            homp_url: "http://www.kbstar.com",
                            cal_tel: "15889999"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0011625",
                            companyName: "신한은행",
                            dcls_chrg_man: "고객솔루션부1577-8000(수신)\n고객솔루션부1577-8000(여신)",
                            homp_url: "http://www.shinhan.com",
                            cal_tel: "15778000"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0013175",
                            companyName: "농협은행주식회사",
                            dcls_chrg_man: "개인고객부, 02-2080-3420(개인 여신 상품), 3395(개인 수신 상품)",
                            homp_url: "https://banking.nonghyup.com",
                            cal_tel: "16613000"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0013909",
                            companyName: "하나은행",
                            dcls_chrg_man: "가계수신(예금) 02-1599-1111(리테일사업부)\n가계여신(대출) 02-2002-1196(리테일사업부)",
                            homp_url: "http://www.hanabank.com",
                            cal_tel: "15991111"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0014674",
                            companyName: "주식회사 케이뱅크",
                            dcls_chrg_man: "수신팀, 02-3210-7312",
                            homp_url: "https://www.kbanknow.com",
                            cal_tel: "15221000"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0014807",
                            companyName: "수협은행",
                            dcls_chrg_man: "개인금융부(수신), 1588-1515\n개인금융부(여신), 1588-1515",
                            homp_url: "http://www.suhyup-bank.com",
                            cal_tel: "15881515"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0015130",
                            companyName: "주식회사 카카오뱅크",
                            dcls_chrg_man: "수신팀 1599-3333\n여신팀 1599-3333",
                            homp_url: "https://www.kakaobank.com/",
                            cal_tel: "15993333"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0017801",
                            companyName: "토스뱅크 주식회사",
                            dcls_chrg_man: "수신 02-2160-5872\n여신 02-2160-5872",
                            homp_url: "https://www.tossbank.com/product-service/savings/account",
                            cal_tel: "16617654"
                        )
                    ],
                    optionList: []
                )
            )
        case .secondBank:
            return FinancialCompanyResponseDTO(
                result: FinancialCompanyResult(
                    prdt_div: "F",
                    total_count: 20,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    financialCompanyInfoList: [
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010345",
                            companyName: "애큐온저축은행",
                            dcls_chrg_man: "경영관리팀 15886161",
                            homp_url: "https://www.acuonsb.co.kr",
                            cal_tel: "15886161"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010346",
                            companyName: "OSB저축은행",
                            dcls_chrg_man: "(예/적금) 고객지원팀 1644-0052 (공시) 전략기획팀 1644-0052",
                            homp_url: "http://osb.co.kr/ib20/mnu/HOM00001",
                            cal_tel: "16440052"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010349",
                            companyName: "디비저축은행",
                            dcls_chrg_man: "고객문의 1600-4902, (공시)개인금융팀 0237051684",
                            homp_url: "http://www.idbsb.com/",
                            cal_tel: "16004902"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010350",
                            companyName: "스카이저축은행",
                            dcls_chrg_man: "영업부, 02-3485-4102",
                            homp_url: "www.skysb.co.kr",
                            cal_tel: "15884111"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010354",
                            companyName: "민국저축은행",
                            dcls_chrg_man: "기획팀, 02-2271-0071",
                            homp_url: "www.mkb.co.kr",
                            cal_tel: "0222710071"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010356",
                            companyName: "푸른저축은행",
                            dcls_chrg_man: "예금/대출문의 : 02-545-9000, 공시부서 : 기획부 : 02-6255-1114",
                            homp_url: "https://www.pureunbank.co.kr/prsb/prwww.html?w2xPath=/w2/itb/main.xml&menu=3&menuNo=344&menuNo=344",
                            cal_tel: "025459000"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010358",
                            companyName: "HB저축은행",
                            dcls_chrg_man: "경영전략팀,0263126571",
                            homp_url: "http://www.hbsb.co.kr",
                            cal_tel: "18338889"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010359",
                            companyName: "키움예스저축은행",
                            dcls_chrg_man: "기획팀, 0261811586",
                            homp_url: "http://www.kiwoomyesbank.com",
                            cal_tel: "025582501"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010363",
                            companyName: "더케이저축은행",
                            dcls_chrg_man: "전략기획팀, 02-569-5600",
                            homp_url: "www.thekbank.co.kr",
                            cal_tel: "025695600"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010366",
                            companyName: "조은저축은행",
                            dcls_chrg_man: "(경영기획팀,0222600740)",
                            homp_url: "http://www.choeunbank.com",
                            cal_tel: "16447200"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010370",
                            companyName: "SBI저축은행",
                            dcls_chrg_man: "고객문의 1566-2210, (공시)리테일기획팀",
                            homp_url: "https://www.sbisb.co.kr",
                            cal_tel: "15662210"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010378",
                            companyName: "바로저축은행",
                            dcls_chrg_man: "(예/적금) 자금효율부 02-3467-2014 (공시) 영업기획팀 02-3467-0136",
                            homp_url: "www.barosavings.com",
                            cal_tel: "0234670100"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010388",
                            companyName: "다올저축은행",
                            dcls_chrg_man: "(고객문의) 1544-6700 (공시담당) 경영전략팀",
                            homp_url: "http://daolsb.com",
                            cal_tel: "15446700"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010389",
                            companyName: "유안타저축은행",
                            dcls_chrg_man: "경영지원팀, 02-6022-3745",
                            homp_url: "http://www.yuantasavings.co.kr",
                            cal_tel: "60223700"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010390",
                            companyName: "고려저축은행",
                            dcls_chrg_man: "영업추진팀,051-640-9052",
                            homp_url: "http://www.goryosb.co.kr",
                            cal_tel: "18779900"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010391",
                            companyName: "국제저축은행",
                            dcls_chrg_man: "수신여신팀, 051-640-2159",
                            homp_url: "http://www.kukjebank.co.kr",
                            cal_tel: "0516362121"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010404",
                            companyName: "DH저축은행",
                            dcls_chrg_man: "수신팀, 051-860-0041",
                            homp_url: "http://www.dhsavingsbank.co.kr",
                            cal_tel: "0518677701"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010416",
                            companyName: "흥국저축은행",
                            dcls_chrg_man: "(경영지원팀, 051-925-2100)",
                            homp_url: "http://www.hkbanking.co.kr",
                            cal_tel: "0519252100"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010418",
                            companyName: "우리저축은행",
                            dcls_chrg_man: "여신팀,0518119414 수신팀,0518119422",
                            homp_url: "http://wooleebank.co.kr",
                            cal_tel: "0518119400"
                        ),
                        FinancialCompanyInfo(
                            dcls_month: "202503",
                            companyCode: "0010419",
                            companyName: "인성저축은행",
                            dcls_chrg_man: "경영기획부 032-865-3911",
                            homp_url: "https://insungsavingsbank.co.kr/PtcShrtInfo_002.act",
                            cal_tel: "0328653911"
                        )
                    ],
                    optionList: []
                )
            )
        }
    }
    */
    func getDepositProduct(type: FinancialCompanyType) -> DepositProductResponseDTO {
        switch type {
        case .all:
            return DepositProductResponseDTO(
                result: DepositProductResult(
                    prdt_div: "D",
                    total_count: 10, // 첫 번째 DTO의 5 + 두 번째 DTO의 5
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    depositProductInfoList: [
                        // 첫 번째 DTO의 depositProductInfoList
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            companyName: "케이뱅크",
                            productName: "코드K 정기예금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후\n- 1개월 이내: 약정이율의 50%\n- 1개월 초과 6개월 이내: 약정이율의 20%\n- 6개월 초과: 약정이율의 10%",
                            preferentialCondition: "최초 가입 고객 우대이율 0.3% 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 3~36개월\n- 최소 가입금액: 10만원 이상",
                            max_limit: 500000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202504011200"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            companyName: "NH농협은행",
                            productName: "NH모바일예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "NH농협카드 보유 시 우대이율 0.2% 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~24개월\n- 최소 가입금액: 50만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011230"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            companyName: "신한은행",
                            productName: "신한베스트예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "신한 신규 고객 대상 0.25% 우대이율",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인 및 개인사업자",
                            etc_note: "- 가입기간: 6~36개월\n- 최소 가입금액: 100만원 이상",
                            max_limit: 1000000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011300"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            companyName: "국민은행",
                            productName: "KB스타예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과 3개월 이내: 약정이율의 25%\n만기 후 3개월 초과: 약정이율의 10%",
                            preferentialCondition: "KB국민카드 결제 실적 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~36개월\n- 최소 가입금액: 30만원 이상",
                            max_limit: 300000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011400"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            companyName: "하나은행",
                            productName: "하나더적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "하나멤버스 가입 시 0.2% 우대이율",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~24개월\n- 최소 가입금액: 20만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011500"
                        ),
                        // 두 번째 DTO의 depositProductInfoList
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            companyName: "SBI저축은행",
                            productName: "SBI정기예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과 6개월 이내: 약정이율의 20%\n만기 후 6개월 초과: 약정이율의 10%",
                            preferentialCondition: "최초 가입 시 0.2% 우대이율 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~36개월\n- 최소 가입금액: 10만원 이상",
                            max_limit: 300000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011000"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            companyName: "OK저축은행",
                            productName: "OK안심정기예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "OK저축은행 모바일 앱 가입 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인 및 개인사업자",
                            etc_note: "- 가입기간: 3~24개월\n- 최소 가입금액: 50만원 이상",
                            max_limit: 500000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202504011100"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            companyName: "웰컴저축은행",
                            productName: "웰컴프리미엄예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "웰컴체크카드 발급 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 12~36개월\n- 최소 가입금액: 100만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011200"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            companyName: "키움저축은행",
                            productName: "키움스마트예금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과 3개월 이내: 약정이율의 20%\n만기 후 3개월 초과: 약정이율의 10%",
                            preferentialCondition: "키움증권 계좌 연계 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~36개월\n- 최소 가입금액: 30만원 이상",
                            max_limit: 200000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011300"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            companyName: "페퍼저축은행",
                            productName: "페퍼더베스트예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "페퍼앱 가입 및 추천인 입력 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~24개월\n- 최소 가입금액: 20만원 이상",
                            max_limit: 400000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011400"
                        )
                    ],
                    depositProductRateInfoList: [
                        // 첫 번째 DTO의 depositProductRateInfoList
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.5,
                            highestRate: 2.8
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.7,
                            highestRate: 3.0
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "3",
                            baseRate: 2.0,
                            highestRate: 2.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.4,
                            highestRate: 2.6
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.6,
                            highestRate: 2.85
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "24",
                            baseRate: 2.7,
                            highestRate: 2.95
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.3,
                            highestRate: 2.45
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.5,
                            highestRate: 2.65
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.2,
                            highestRate: 2.4
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.45,
                            highestRate: 2.65
                        ),
                        // 두 번째 DTO의 depositProductRateInfoList
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.5
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "3",
                            baseRate: 2.8,
                            highestRate: 2.95
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.35
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.4,
                            highestRate: 3.7
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "24",
                            baseRate: 3.5,
                            highestRate: 3.8
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.1,
                            highestRate: 3.35
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.55
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.25,
                            highestRate: 3.45
                        )
                    ]
                )
            )
        case .firstBank:
            return DepositProductResponseDTO(
                result: DepositProductResult(
                    prdt_div: "D",
                    total_count: 5,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    depositProductInfoList: [
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            companyName: "케이뱅크",
                            productName: "코드K 정기예금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후\n- 1개월 이내: 약정이율의 50%\n- 1개월 초과 6개월 이내: 약정이율의 20%\n- 6개월 초과: 약정이율의 10%",
                            preferentialCondition: "최초 가입 고객 우대이율 0.3% 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 3~36개월\n- 최소 가입금액: 10만원 이상",
                            max_limit: 500000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202504011200"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            companyName: "NH농협은행",
                            productName: "NH모바일예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "NH농협카드 보유 시 우대이율 0.2% 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~24개월\n- 최소 가입금액: 50만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011230"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            companyName: "신한은행",
                            productName: "신한베스트예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "신한 신규 고객 대상 0.25% 우대이율",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인 및 개인사업자",
                            etc_note: "- 가입기간: 6~36개월\n- 최소 가입금액: 100만원 이상",
                            max_limit: 1000000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011300"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            companyName: "국민은행",
                            productName: "KB스타예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과 3개월 이내: 약정이율의 25%\n만기 후 3개월 초과: 약정이율의 10%",
                            preferentialCondition: "KB국민카드 결제 실적 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~36개월\n- 최소 가입금액: 30만원 이상",
                            max_limit: 300000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011400"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            companyName: "하나은행",
                            productName: "하나더적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "하나멤버스 가입 시 0.2% 우대이율",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~24개월\n- 최소 가입금액: 20만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011500"
                        )
                    ],
                    depositProductRateInfoList: [
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.5,
                            highestRate: 2.8
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010020",
                            productCode: "KD1234A",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.7,
                            highestRate: 3.0
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "3",
                            baseRate: 2.0,
                            highestRate: 2.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010021",
                            productCode: "NH5678B",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.4,
                            highestRate: 2.6
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.6,
                            highestRate: 2.85
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010022",
                            productCode: "SH9012C",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "24",
                            baseRate: 2.7,
                            highestRate: 2.95
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.3,
                            highestRate: 2.45
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010023",
                            productCode: "KB3456D",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.5,
                            highestRate: 2.65
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 2.2,
                            highestRate: 2.4
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0010024",
                            productCode: "HN7890E",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 2.45,
                            highestRate: 2.65
                        )
                    ]
                )
            )
        case .secondBank:
            return DepositProductResponseDTO(
                result: DepositProductResult(
                    prdt_div: "D",
                    total_count: 5,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    depositProductInfoList: [
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            companyName: "SBI저축은행",
                            productName: "SBI정기예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과 6개월 이내: 약정이율의 20%\n만기 후 6개월 초과: 약정이율의 10%",
                            preferentialCondition: "최초 가입 시 0.2% 우대이율 제공",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~36개월\n- 최소 가입금액: 10만원 이상",
                            max_limit: 300000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011000"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            companyName: "OK저축은행",
                            productName: "OK안심정기예금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "OK저축은행 모바일 앱 가입 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인 및 개인사업자",
                            etc_note: "- 가입기간: 3~24개월\n- 최소 가입금액: 50만원 이상",
                            max_limit: 500000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202504011100"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            companyName: "웰컴저축은행",
                            productName: "웰컴프리미엄예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "웰컴체크카드 발급 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 12~36개월\n- 최소 가입금액: 100만원 이상",
                            max_limit: nil,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011200"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            companyName: "키움저축은행",
                            productName: "키움스마트예금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과 3개월 이내: 약정이율의 20%\n만기 후 3개월 초과: 약정이율의 10%",
                            preferentialCondition: "키움증권 계좌 연계 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 1~36개월\n- 최소 가입금액: 30만원 이상",
                            max_limit: 200000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011300"
                        ),
                        DepositProductInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            companyName: "페퍼저축은행",
                            productName: "페퍼더베스트예금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "페퍼앱 가입 및 추천인 입력 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "- 가입기간: 6~24개월\n- 최소 가입금액: 20만원 이상",
                            max_limit: 400000000,
                            dcls_strt_day: "20250401",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202504011400"
                        )
                    ],
                    depositProductRateInfoList: [
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020001",
                            productCode: "SBK1001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.5
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "3",
                            baseRate: 2.8,
                            highestRate: 2.95
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.35
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.4,
                            highestRate: 3.7
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020003",
                            productCode: "WLS3003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "24",
                            baseRate: 3.5,
                            highestRate: 3.8
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.1,
                            highestRate: 3.35
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020004",
                            productCode: "KJS4004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.55
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        DepositProductRateInfo(
                            dcls_month: "202504",
                            companyCode: "0020005",
                            productCode: "PFS5005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            depositMonth: "12",
                            baseRate: 3.25,
                            highestRate: 3.45
                        )
                    ]
                )
            )
        }
    }
    
    func getSavingProduct(type: FinancialCompanyType) -> SavingProductResponseDTO {
        switch type {
        case .all:
            return SavingProductResponseDTO(
                result: SavingProductResult(
                    prdt_div: "S",
                    total_count: 10, // 첫 번째 DTO의 5 + 두 번째 DTO의 5
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    savingProductInfoList: [
                        // 첫 번째 DTO (.firstBank)의 savingProductInfoList
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            companyName: "우리은행",
                            productName: "우리SUPER주거래적금",
                            join_way: "영업점,인터넷,스마트폰,전화(텔레뱅킹)",
                            mtrt_int: "만기 후\n- 1개월이내 : 만기시점약정이율×50%\n- 1개월초과 6개월이내: 만기시점약정이율×30%\n- 6개월초과 : 만기시점약정이율×20%\n\n※ 만기시점 약정이율 : 일반정기적금 금리",
                            preferentialCondition: "1.거래실적 인정기간 동안 우리은행 입출식 계좌에서 아래각 항목별 실적이 있는 월 수가 계약기간의 1/2이상인 경우 가. 급여/연금 이체:연0.7%p 나.공과금 자동이체 출금 실적:0.3%p 다.10만원 이상출금: 연0.3%p2. 전화(휴대폰) 및 SMS항목을 모두 동의한후 만기해지시점까지유지:연 0.1%p 3.이 상품 가입 시 금리우대쿠폰을 적용한 경우",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 1년/2년/3년\n2. 가입금액 : 월 50만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201011"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            companyName: "NH농협은행",
                            productName: "NH행복적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "NH농협카드 결제 실적 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/36개월\n2. 가입금액 : 월 40만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201100"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            companyName: "신한은행",
                            productName: "신한베스트적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "신한카드 월 50만원 이상 사용 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201200"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            companyName: "국민은행",
                            productName: "KB스타적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "KB국민카드 결제 실적 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 50만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201300"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            companyName: "하나은행",
                            productName: "하나든든적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "하나멤버스 가입 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 20만원 이내",
                            max_limit: 15000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201400"
                        ),
                        // 두 번째 DTO (.secondBank)의 savingProductInfoList
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            companyName: "SBI저축은행",
                            productName: "SBI자유적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "SBI 모바일 앱 가입 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201100"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            companyName: "OK저축은행",
                            productName: "OK정기적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "월 10만원 이상 납입 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월\n2. 가입금액 : 월 20만원 이내",
                            max_limit: 30000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202503201200"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            companyName: "웰컴저축은행",
                            productName: "웰컴프리미엄적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "웰컴체크카드 발급 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 50만원 이내",
                            max_limit: 25000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201300"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            companyName: "키움저축은행",
                            productName: "키움꿈나무적금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "키움증권 계좌 동시 보유 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 15000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201400"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            companyName: "페퍼저축은행",
                            productName: "페퍼든든적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "페퍼앱 추천인 입력 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 40만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201500"
                        )
                    ],
                    savingProductRateInfoList: [
                        // 첫 번째 DTO (.firstBank)의 savingProductRateInfoList
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.6,
                            highestRate: 4.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "24",
                            baseRate: 2.6,
                            highestRate: 4.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 2.8,
                            highestRate: 3.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 2.9,
                            highestRate: 3.1
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.7,
                            highestRate: 3.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 2.8,
                            highestRate: 3.1
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 2.5,
                            highestRate: 2.7
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 2.6,
                            highestRate: 2.8
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.7,
                            highestRate: 2.95
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 2.8,
                            highestRate: 3.05
                        ),
                        // 두 번째 DTO (.secondBank)의 savingProductRateInfoList
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.5
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.35
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.4,
                            highestRate: 3.55
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.6
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.5,
                            highestRate: 3.8
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 3.1,
                            highestRate: 3.35
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.55
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.4
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.4,
                            highestRate: 3.6
                        )
                    ]
                )
            )
        case .firstBank:
            return SavingProductResponseDTO(
                result: SavingProductResult(
                    prdt_div: "S",
                    total_count: 5,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    savingProductInfoList: [
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            companyName: "우리은행",
                            productName: "우리SUPER주거래적금",
                            join_way: "영업점,인터넷,스마트폰,전화(텔레뱅킹)",
                            mtrt_int: "만기 후\n- 1개월이내 : 만기시점약정이율×50%\n- 1개월초과 6개월이내: 만기시점약정이율×30%\n- 6개월초과 : 만기시점약정이율×20%\n\n※ 만기시점 약정이율 : 일반정기적금 금리",
                            preferentialCondition: "1.거래실적 인정기간 동안 우리은행 입출식 계좌에서 아래각 항목별 실적이 있는 월 수가 계약기간의 1/2이상인 경우 가. 급여/연금 이체:연0.7%p 나.공과금 자동이체 출금 실적:0.3%p 다.10만원 이상출금: 연0.3%p2. 전화(휴대폰) 및 SMS항목을 모두 동의한후 만기해지시점까지유지:연 0.1%p 3.이 상품 가입 시 금리우대쿠폰을 적용한 경우",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 1년/2년/3년\n2. 가입금액 : 월 50만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201011"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            companyName: "NH농협은행",
                            productName: "NH행복적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "NH농협카드 결제 실적 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/36개월\n2. 가입금액 : 월 40만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201100"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            companyName: "신한은행",
                            productName: "신한베스트적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "신한카드 월 50만원 이상 사용 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201200"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            companyName: "국민은행",
                            productName: "KB스타적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "KB국민카드 결제 실적 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 50만원 이내",
                            max_limit: nil,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201300"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            companyName: "하나은행",
                            productName: "하나든든적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "하나멤버스 가입 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 20만원 이내",
                            max_limit: 15000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201400"
                        )
                    ],
                    savingProductRateInfoList: [
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.6,
                            highestRate: 4.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010001",
                            productCode: "WR0001F",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "24",
                            baseRate: 2.6,
                            highestRate: 4.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 2.8,
                            highestRate: 3.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010002",
                            productCode: "NHK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 2.9,
                            highestRate: 3.1
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.7,
                            highestRate: 3.0
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010003",
                            productCode: "SHN2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 2.8,
                            highestRate: 3.1
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 2.5,
                            highestRate: 2.7
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010004",
                            productCode: "KBN2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 2.6,
                            highestRate: 2.8
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 2.7,
                            highestRate: 2.95
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0010005",
                            productCode: "HNK2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 2.8,
                            highestRate: 3.05
                        )
                    ]
                )
            )
        case .secondBank:
            return SavingProductResponseDTO(
                result: SavingProductResult(
                    prdt_div: "S",
                    total_count: 5,
                    max_page_no: 1,
                    now_page_no: 1,
                    err_cd: "000",
                    err_msg: "정상",
                    savingProductInfoList: [
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            companyName: "SBI저축은행",
                            productName: "SBI자유적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "SBI 모바일 앱 가입 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201100"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            companyName: "OK저축은행",
                            productName: "OK정기적금",
                            join_way: "영업점,인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 60%\n만기 후 1개월 초과: 약정이율의 30%",
                            preferentialCondition: "월 10만원 이상 납입 시 0.15% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월\n2. 가입금액 : 월 20만원 이내",
                            max_limit: 30000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: "20251231",
                            fin_co_subm_day: "202503201200"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            companyName: "웰컴저축은행",
                            productName: "웰컴프리미엄적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 55%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "웰컴체크카드 발급 시 0.3% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 50만원 이내",
                            max_limit: 25000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201300"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            companyName: "키움저축은행",
                            productName: "키움꿈나무적금",
                            join_way: "스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 25%",
                            preferentialCondition: "키움증권 계좌 동시 보유 시 0.25% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 6개월/12개월/24개월\n2. 가입금액 : 월 30만원 이내",
                            max_limit: 15000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201400"
                        ),
                        SavingProductInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            companyName: "페퍼저축은행",
                            productName: "페퍼든든적금",
                            join_way: "인터넷,스마트폰",
                            mtrt_int: "만기 후 1개월 이내: 약정이율의 50%\n만기 후 1개월 초과: 약정이율의 20%",
                            preferentialCondition: "페퍼앱 추천인 입력 시 0.2% 우대",
                            joinRestrict: "1",
                            joinTarget: "실명의 개인",
                            etc_note: "1. 가입기간 : 12개월/24개월/36개월\n2. 가입금액 : 월 40만원 이내",
                            max_limit: 20000000,
                            dcls_strt_day: "20250320",
                            dcls_end_day: nil,
                            fin_co_subm_day: "202503201500"
                        )
                    ],
                    savingProductRateInfoList: [
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 3.0,
                            highestRate: 3.2
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020001",
                            productCode: "SBK2001",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.5
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.35
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020002",
                            productCode: "OKS2002",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.4,
                            highestRate: 3.55
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.6
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020003",
                            productCode: "WLS2003",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.5,
                            highestRate: 3.8
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "6",
                            baseRate: 3.1,
                            highestRate: 3.35
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020004",
                            productCode: "KJS2004",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "F",
                            savingMethod: "자유적립식",
                            savingMonth: "12",
                            baseRate: 3.3,
                            highestRate: 3.55
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "12",
                            baseRate: 3.2,
                            highestRate: 3.4
                        ),
                        SavingProductRateInfo(
                            dcls_month: "202503",
                            companyCode: "0020005",
                            productCode: "PFS2005",
                            intr_rate_type: "S",
                            rateMethod: "단리",
                            rsrv_type: "S",
                            savingMethod: "정액적립식",
                            savingMonth: "24",
                            baseRate: 3.4,
                            highestRate: 3.6
                        )
                    ]
                )
            )
        }
    }
}
