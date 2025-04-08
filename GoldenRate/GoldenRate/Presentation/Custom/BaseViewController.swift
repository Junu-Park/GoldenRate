//
//  BaseViewController.swift
//  GoldenRate
//
//  Created by 박준우 on 3/26/25.
//

import UIKit

class BaseViewController: UIViewController, ConfigureProtocol {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureDefaultSetting()
        self.configureHierarchy()
        // TODO: 계산기뷰 구현 오류 해결을 위한 임시 순서 변경
        self.configureView()
        self.configureLayout()
        self.bind()
    }
    
    private func configureDefaultSetting() {
        self.view = BaseView()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
    func bind() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
