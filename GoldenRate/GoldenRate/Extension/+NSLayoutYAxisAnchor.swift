//
//  +NSLayoutYAxisAnchor.swift
//  GoldenRate
//
//  Created by 박준우 on 7/8/25.
//

import UIKit

extension NSLayoutYAxisAnchor: NSLayoutAnchorName {
    
    func constraint(equalTo view: UIView?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let view else { return nil }
        guard let anchor = self.anchorName else { return nil }
        
        switch anchor {
        case "top":
            return self.constraint(equalTo: view.topAnchor, constant: constant)
        case "bottom":
            return self.constraint(equalTo: view.bottomAnchor, constant: constant)
        case "centerY":
            return self.constraint(equalTo: view.centerYAnchor, constant: constant)
        default:
            return nil
        }
    }
    
    func constraint(equalTo safeArea: UILayoutGuide?, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let safeArea else { return nil }
        guard let anchor = self.anchorName else { return nil }
        
        switch anchor {
        case "top":
            return self.constraint(equalTo: safeArea.topAnchor, constant: constant)
        case "bottom":
            return self.constraint(equalTo: safeArea.bottomAnchor, constant: constant)
        case "centerY":
            return self.constraint(equalTo: safeArea.centerYAnchor, constant: constant)
        default:
            return nil
        }
    }
}
