//
//  +NSAttributedString.swift
//  GoldenRate
//
//  Created by 박준우 on 4/2/25.
//

import UIKit

extension NSAttributedString {
    convenience init(totalString: String, totalColor: UIColor, totalFont: UIFont, targetString: String, targetColor: UIColor, targetFont: UIFont) {
        let fullString = NSMutableAttributedString(string: totalString, attributes: [.foregroundColor: totalColor, .font: totalFont])
        let targetStringRange = (totalString as NSString).range(of: targetString)
        fullString.addAttributes([.foregroundColor: targetColor, .font: targetFont], range: targetStringRange)
        self.init(attributedString: fullString)
    }
}
