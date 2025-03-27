//
//  BaseView.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import UIKit

class BaseView: UIView, ConfigureProtocol {
    
    init() {
        super.init(frame: .zero)
        
        self.configureDefaultSetting()
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
    }
    
    private func configureDefaultSetting() {
        self.backgroundColor = .background
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
