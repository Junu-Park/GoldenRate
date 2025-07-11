//
//  CalculatorTextFieldView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/10/25.
//

import Combine
import UIKit

enum CalculatorTextFieldType: Equatable {
    case amount(productType: ProductType)
    case interestRate
    case period(periodType: PeriodType)
    
    var title: String {
        switch self {
        case .amount(let productType):
            return productType == .deposit ? "예치 금액" : "월 납입액"
        case .interestRate:
            return "연 이율"
        case .period:
            return "예치 기간"
        }
    }
    
    var unit: String? {
        switch self {
        case .amount:
            return "원"
        case .interestRate:
            return "%"
        case .period(let periodType):
            return periodType.rawValue
        }
    }
}

final class CalculatorTextFieldView: BaseView {
    
    private let titleLabel: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    private let unitLabel: UILabel = UILabel()
    
    private var type: CalculatorTextFieldType
    
    init(calculatorTextFieldType: CalculatorTextFieldType) {
        self.type = calculatorTextFieldType
        
        super.init()
        
        self.setView(calculatorTextFieldType: calculatorTextFieldType)
    }
    
    override func configureHierarchy() {
        self.addSubviews(self.titleLabel, self.textField, self.unitLabel)
    }
    
    override func configureLayout() {
        self.titleLabel.setConstraints {
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            $0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        }
        
        self.textField.setConstraints {
            $0.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 8)
            $0.topAnchor.constraint(equalTo: self.topAnchor)
            $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            $0.heightAnchor.constraint(equalToConstant: 44)
        }
        
        self.unitLabel.setConstraints {
            $0.leadingAnchor.constraint(equalTo: self.textField.trailingAnchor, constant: 8)
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            $0.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            $0.widthAnchor.constraint(equalToConstant: 30)
        }
    }
    
    override func configureView() {
        self.titleLabel.font = .bold16
        self.titleLabel.textColor = .text
        
        self.textField.delegate = self
        self.textField.borderStyle = .roundedRect
        self.textField.rightView = UIView(frame: .init(x: 0, y: 0, width: 4, height: 0))
        self.textField.rightViewMode = .always
        self.textField.layer.cornerRadius = 5
        self.textField.font = .bold16
        self.textField.textColor = .defaultText
        self.textField.tintColor = .defaultText
        self.textField.backgroundColor = .defaultBackground
        self.textField.textAlignment = .right
        
        self.unitLabel.font = .regular16
        self.unitLabel.textColor = .defaultGray
        
        switch self.type {
        case .amount, .period:
            self.textField.keyboardType = .numberPad
        case .interestRate:
            self.textField.keyboardType = .decimalPad
        }
    }
    
    func setView(calculatorTextFieldType: CalculatorTextFieldType) {
        self.type = calculatorTextFieldType
        
        self.titleLabel.text = calculatorTextFieldType.title
        
        self.unitLabel.text = calculatorTextFieldType.unit
    }
}

extension CalculatorTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
            return true
        }
        
        guard let text = textField.text else {
            return false
        }
        
        if string == "." && text.contains(string) {
            return false
        }
        
        let totalString = text + string
        let value = Double(totalString.replacingOccurrences(of: ",", with: "")) ?? 0
        if (self.type == .amount(productType: .deposit) || self.type == .amount(productType: .saving)) && value > 1000000000000 {
            return false
        }
        
        if self.type == .interestRate && value > 100 {
            return false
        }
        
        if (self.type == .period(periodType: .year) || self.type == .period(periodType: .month)) && value > 1000 {
            return false
        }
        
        let allowedCharacters = self.type == .interestRate ? CharacterSet(charactersIn: "0123456789.") : CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        if text.hasPrefix(".") {
            self.textField.text = "0" + text
        }
        
        let filteredText = text.replacingOccurrences(of: ",", with: "")
        
        if filteredText.contains(".") {
            if filteredText.hasPrefix(".") {
                self.textField.text = "0" + filteredText
            } else {
                let separatedText = filteredText.components(separatedBy: ".")
                let intText = separatedText[0]
                let decimalText = separatedText[1]
                let formattedIntText = (Double(intText) ?? 0).formatted()
                self.textField.text = formattedIntText + "." + decimalText
            }
        } else {
            let doubleText = Double(filteredText) ?? 0
            self.textField.text = doubleText.formatted()
        }
    }
}

extension CalculatorTextFieldView {
    var publisher: AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.textField)
            .compactMap { [weak self] _ in
                guard let self, let text = self.textField.text else {
                    return nil
                }
                return text.replacingOccurrences(of: ",", with: "")
            }
            .eraseToAnyPublisher()
    }
}
