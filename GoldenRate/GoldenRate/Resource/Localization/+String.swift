//
//  +String.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
