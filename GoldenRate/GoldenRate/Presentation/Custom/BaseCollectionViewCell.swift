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
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
