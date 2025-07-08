//
//  ConstraintsBuilder.swift
//  GoldenRate
//
//  Created by 박준우 on 6/28/25.
//

import UIKit

@resultBuilder
struct ConstraintsBuilder {
    static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        return components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
        return [expression]
    }
    
    static func buildExpression(_ expression: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return expression
    }
    
    static func buildExpression(_ expression: NSLayoutConstraint?) -> [NSLayoutConstraint] {
        guard let expression else { return [] }
        return [expression]
    }
}
