//
//  ReusableIdentifier.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import Foundation

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier {
    static var identifier: String {
        return "\(Self.self)"
    }
}
