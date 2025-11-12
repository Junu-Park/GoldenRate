//
//  BaseCollectionViewCell.swift
//  GoldenRate
//
//  Created by 박준우 on 4/1/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ConfigureProtocol, ReusableIdentifier {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
        
        if #available(iOS 17.0, *) {
            self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.setShadowBorderColor()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #unavailable(iOS 17.0) {
            self.setShadowBorderColor()
        }
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
