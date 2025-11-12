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
