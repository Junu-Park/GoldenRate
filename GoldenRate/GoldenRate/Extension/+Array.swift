//
//  +Array.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension Array where Element == NSLayoutYAxisAnchor {
    func constraints(equalTo view: UIView, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            self[0].constraint(equalTo: view.topAnchor, constant: constant),
            self[1].constraint(equalTo: view.bottomAnchor, constant: -constant)
        ]
    }
}

extension Array where Element == NSLayoutXAxisAnchor {
    func constraints(equalTo view: UIView, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            self[0].constraint(equalTo: view.leadingAnchor, constant: constant),
            self[1].constraint(equalTo: view.trailingAnchor, constant: -constant)
        ]
    }
}
