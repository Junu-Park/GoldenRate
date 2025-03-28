//
//  CustomSegmentedControl.swift
//  GoldenRate
//
//  Created by 박준우 on 4/2/25.
//

import UIKit

final class CustomSegmentedControl<T: RawRepresentable>: UISegmentedControl where T.RawValue == String {
    
    private lazy var underline: UIView = UIView()
    
    init(items: [T], isDynamicSize: Bool = false) {
        super.init(items: [])
        
        self.apportionsSegmentWidthsByContent = isDynamicSize
        
        for (index,item) in items.enumerated() {
            self.insertSegment(withTitle: item.rawValue, at: index, animated: true)
        }

        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.changeSegment()
    }
    
    private func configureHierarchy() {
        self.addSubviews(self.underline)
    }
    
    private func configureLayout() {
        self.underline.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.5)
            $0.width.leading.equalTo(0)
        }
    }
    
    private func configureView() {
        self.clipsToBounds = false
        self.selectedSegmentIndex = 0
        self.setTitleTextAttributes([.foregroundColor: UIColor.defaultText, .font: UIFont.bold14], for: .selected)
        self.setTitleTextAttributes([.foregroundColor: UIColor.defaultGray, .font: UIFont.regular14], for: .normal)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        [UIControl.State.normal, UIControl.State.selected, UIControl.State.highlighted].forEach {
            self.setBackgroundImage(UIImage(), for: $0, barMetrics: .default)
        }
        self.addTarget(self, action: #selector(self.changeSegment), for: .valueChanged)
        
        self.underline.backgroundColor = .accent
    }
    
    @discardableResult @objc private func changeSegment() -> Int {
        let view = self.subviews[self.selectedSegmentIndex]
        
        UIView.animate(withDuration: 0.3) {
            self.underline.snp.updateConstraints {
                $0.leading.equalTo(view.frame.origin.x)
                $0.width.equalTo(view.frame.width)
            }
            self.layoutIfNeeded()
        }
        return self.selectedSegmentIndex
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
