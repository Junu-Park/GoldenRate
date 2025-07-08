//
//  +NSLayoutXAxisAnchor.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension NSLayoutXAxisAnchor {
    func constraint(equalTo view: UIView?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let view else { return nil }
        
        switch self {
        case view.leadingAnchor:
            return self.constraint(equalTo: view.leadingAnchor, constant: constant)
        case view.trailingAnchor:
            return self.constraint(equalTo: view.trailingAnchor, constant: constant)
        case view.centerXAnchor:
            return self.constraint(equalTo: view.centerXAnchor, constant: constant)
        default:
            return nil
        }
    }
}
