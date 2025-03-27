//
//  BaseViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import UIKit

class BaseViewController: UIViewController, ConfigureProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDefaultSetting()
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
    }
    
    private func configureDefaultSetting() {
        self.view = BaseView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
