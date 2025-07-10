//
//  +Array.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension Array where Element == NSLayoutYAxisAnchor {
    func constraints(equalTo view: UIView?, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let view else { return [] }
        return [
            self[0].constraint(equalTo: view.topAnchor, constant: constant),
            self[1].constraint(equalTo: view.bottomAnchor, constant: -constant)
        ]
    }
    
    func constraints(equalTo safeArea: UILayoutGuide?, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let safeArea else { return [] }
        return [
            self[0].constraint(equalTo: safeArea.topAnchor, constant: constant),
            self[1].constraint(equalTo: safeArea.bottomAnchor, constant: -constant)
        ]
    }
}

extension Array where Element == NSLayoutXAxisAnchor {
    func constraints(equalTo view: UIView?, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let view else { return [] }
        
        return [
            self[0].constraint(equalTo: view.leadingAnchor, constant: constant),
            self[1].constraint(equalTo: view.trailingAnchor, constant: -constant)
        ]
    }
    
    func constraints(equalTo safeArea: UILayoutGuide?, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let safeArea else { return [] }
        return [
            self[0].constraint(equalTo: safeArea.leadingAnchor, constant: constant),
            self[1].constraint(equalTo: safeArea.trailingAnchor, constant: -constant)
        ]
    }
}
