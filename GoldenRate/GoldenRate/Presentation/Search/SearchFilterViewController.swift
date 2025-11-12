//
//  SearchFilterViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import UIKit

import FirebaseAnalytics

final class SearchFilterViewController: BaseViewController {
    
    private let financialCompanyTypeTitle: UILabel = UILabel()
    private let financialCompanyTypeFilter: CustomSegmentedControl = CustomSegmentedControl(items: FinancialCompanyType.allCases)
    private let interestRateTypeTitle: UILabel = UILabel()
    private let interestRateTypeFilter: CustomSegmentedControl = CustomSegmentedControl(items: InterestRateType.allCases)
    private let productSortTypeTitle: UILabel = UILabel()
    private let productSortTypeFilter: CustomSegmentedControl = CustomSegmentedControl(items: ProductSortType.allCases)
    private let applyButton: UIButton = UIButton()
    
    private var filter: SearchFilter
    var applyClosure: ((SearchFilter) -> ())?
    
    init(filter: SearchFilter) {
        self.filter = filter
        self.financialCompanyTypeFilter.selectedSegmentIndex = FinancialCompanyType.allCases.firstIndex(of: filter.financialCompanyType) ?? 0
        self.interestRateTypeFilter.selectedSegmentIndex = InterestRateType.allCases.firstIndex(of: filter.interestRateType) ?? 0
        self.productSortTypeFilter.selectedSegmentIndex = ProductSortType.allCases.firstIndex(of: filter.productSortType) ?? 0
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        [self.financialCompanyTypeFilter, self.interestRateTypeFilter, self.productSortTypeFilter].forEach { view in
            view.setShadowBorderColor()
        }
    }
    
    override func configureHierarchy() {
        self.view.addSubviews(self.financialCompanyTypeTitle, self.financialCompanyTypeFilter, self.interestRateTypeTitle, self.interestRateTypeFilter, self.productSortTypeTitle, self.productSortTypeFilter, self.applyButton)
    }
    
    override func configureLayout() {
        self.financialCompanyTypeTitle.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview, constant: 32)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
        }
        
        self.financialCompanyTypeFilter.setConstraints {
            $0.topAnchor.constraint(equalTo: self.financialCompanyTypeTitle.bottomAnchor, constant: 8)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        
        self.interestRateTypeTitle.setConstraints {
            $0.topAnchor.constraint(equalTo: self.financialCompanyTypeFilter.bottomAnchor, constant: 32)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
        }
        
        self.interestRateTypeFilter.setConstraints {
            $0.topAnchor.constraint(equalTo: self.interestRateTypeTitle.bottomAnchor, constant: 8)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        self.productSortTypeTitle.setConstraints {
            $0.topAnchor.constraint(equalTo: self.interestRateTypeFilter.bottomAnchor, constant: 32)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
        }
        self.productSortTypeFilter.setConstraints {
            $0.topAnchor.constraint(equalTo: self.productSortTypeTitle.bottomAnchor, constant: 8)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 40)
        }
        self.applyButton.setConstraints {
            $0.topAnchor.constraint(equalTo: self.productSortTypeFilter.bottomAnchor, constant: 32)
            $0.horizontalAnchor.constraints(equalTo: $0.superview, constant: 16)
            $0.heightAnchor.constraint(equalToConstant: 50)
        }
    }
    
    override func configureView() {
        self.financialCompanyTypeTitle.text = "은행 종류"
        self.interestRateTypeTitle.text = "이자 계산 방식"
        self.productSortTypeTitle.text = "정렬 방식"
        [self.financialCompanyTypeTitle, self.interestRateTypeTitle, self.productSortTypeTitle].forEach { view in
            view.font = .bold20
            view.textColor = .text
        }
        
        for (index, view) in [self.financialCompanyTypeFilter, self.interestRateTypeFilter, self.productSortTypeFilter].enumerated() {
            view.tag = index + 1
            view.setShadowBorder()
            view.backgroundColor = .defaultBackground
            view.addTarget(self, action: #selector(filterValueChanged), for: .valueChanged)
        }
        
        var buttonConfig = UIButton.Configuration.bordered()
        buttonConfig.attributedTitle = .init("적용하기", attributes: AttributeContainer([.foregroundColor: UIColor.accent, .font: UIFont.bold20]))
        buttonConfig.baseBackgroundColor = .defaultBackground
        self.applyButton.configuration = buttonConfig
        self.applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func filterValueChanged(_ sender: UISegmentedControl) {
        switch sender.tag {
        case 1:
            self.filter.financialCompanyType = .init(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "전체") ?? .all
        case 2:
            self.filter.interestRateType = .init(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "전체") ?? .all
        case 3:
            self.filter.productSortType = .init(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "기본순") ?? .basic
        default:
            break
        }
    }
    
    @objc private func applyButtonTapped() {
        Analytics.logEvent("SearchFilterApplyButton_Tap", parameters: ["financialCompanyType": self.filter.financialCompanyType.rawValue, "interestRateType": self.filter.interestRateType.rawValue, "productSortType": self.filter.productSortType.rawValue])
        self.applyClosure?(self.filter)
        self.dismiss(animated: true)
    }
}
