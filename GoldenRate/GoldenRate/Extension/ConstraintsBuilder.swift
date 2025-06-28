//
//  ConstraintsBuilder.swift
//  GoldenRate
//
//  Created by 박준우 on 6/28/25.
//

import UIKit

@resultBuilder
struct ConstraintsBuilder {
    static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        return components
    }
}
