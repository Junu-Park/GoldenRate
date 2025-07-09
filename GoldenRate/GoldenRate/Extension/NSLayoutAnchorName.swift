//
//  NSLayoutAnchorName.swift
//  GoldenRate
//
//  Created by 박준우 on 7/9/25.
//

import Foundation

protocol NSLayoutAnchorName {
    var anchorName: String? { get }
}

extension NSLayoutAnchorName {
    var anchorName: String? {
        let selfString = String(describing: self)
        guard let pointIndex = selfString.lastIndex(of: ".") else { return nil }
        let startIndex = selfString.index(after: pointIndex)
        guard let endIndex = selfString.lastIndex(of: "\"") else { return nil }
        
        return String(selfString[startIndex..<endIndex])
    }
}
