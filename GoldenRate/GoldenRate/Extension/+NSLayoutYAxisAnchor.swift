//
//  +NSLayoutYAxisAnchor.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension NSLayoutYAxisAnchor {
    func constraint(equalTo view: UIView?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let view else { return nil }
        
        switch self {
        case view.topAnchor:
            return self.constraint(equalTo: view.topAnchor, constant: constant)
        case view.bottomAnchor:
            return self.constraint(equalTo: view.bottomAnchor, constant: constant)
        case view.centerYAnchor:
            return self.constraint(equalTo: view.centerYAnchor, constant: constant)
        default:
            return nil
        }
    }
}
