//
//  +UIView.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
    func setShadowBorder() {
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.defaultText.cgColor
    }
    
    
}

// Constraint 관련 extension
extension UIView {
    var verticalAnchor: [NSLayoutYAxisAnchor] {
        return [self.topAnchor, self.bottomAnchor]
    }
    
    var horizontalAnchor: [NSLayoutXAxisAnchor] {
        return [self.leadingAnchor, self.trailingAnchor]
    }
    
    func setConstraints(@ConstraintsBuilder constraintsClosure: (UIView) -> [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = constraintsClosure(self)
        NSLayoutConstraint.activate(constraints)
    }
}
