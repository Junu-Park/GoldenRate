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
}
