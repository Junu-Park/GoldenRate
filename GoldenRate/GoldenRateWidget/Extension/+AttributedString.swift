//
//  +AttributedString.swift
//  GoldenRate
//
//  Created by 박준우 on 4/23/25.
//

import SwiftUI

extension AttributedString {
    init(totalString: String, totalColor: Color, totalFont: Font, targetString: String, targetColor: Color, targetFont: Font) {
        var attributedString = AttributedString(totalString)
        
        attributedString.foregroundColor = totalColor
        attributedString.font = totalFont
        
        if let range = attributedString.range(of: targetString) {
            attributedString[range].foregroundColor = targetColor
            attributedString[range].font = targetFont
        }
        
        self = attributedString
    }
}
