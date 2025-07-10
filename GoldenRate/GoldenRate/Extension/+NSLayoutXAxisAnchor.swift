//
//  +NSLayoutXAxisAnchor.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension NSLayoutXAxisAnchor: NSLayoutAnchorName {
    
    func constraint(equalTo view: UIView?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let view else { return nil }
        guard let anchor = self.anchorName else { return nil }
        
        switch anchor {
        case "leading":
            return self.constraint(equalTo: view.leadingAnchor, constant: constant)
        case "trailing":
            return self.constraint(equalTo: view.trailingAnchor, constant: constant)
        case "centerX":
            return self.constraint(equalTo: view.centerXAnchor, constant: constant)
        default:
            return nil
        }
    }
    
    func constraint(equalTo safeArea: UILayoutGuide?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let safeArea else { return nil }
        guard let anchor = self.anchorName else { return nil }
        
        switch anchor {
        case "leading":
            return self.constraint(equalTo: safeArea.leadingAnchor, constant: constant)
        case "trailing":
            return self.constraint(equalTo: safeArea.trailingAnchor, constant: constant)
        case "centerX":
            return self.constraint(equalTo: safeArea.centerXAnchor, constant: constant)
        default:
            return nil
        }
    }
}
