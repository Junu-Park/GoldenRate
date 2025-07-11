//
//  CustomSegmentedControl.swift
//  GoldenRate
//
//  Created by 박준우 on 4/2/25.
//

import Combine
import UIKit

final class CustomSegmentedControl<T: RawRepresentable>: UISegmentedControl where T.RawValue == String {
    let items: [T]
    private lazy var underline: UIView = UIView()
    
    private var underlineLeadingConstraint: NSLayoutConstraint?
    private var underlineWidthConstraint: NSLayoutConstraint?
    
    init(items: [T], isDynamicSize: Bool = false) {
        self.items = items
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
        
        self.underlineLeadingConstraint = underline.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        self.underlineWidthConstraint = underline.widthAnchor.constraint(equalToConstant: 0)
        
        self.underline.setConstraints {
            self.underlineLeadingConstraint
            $0.bottomAnchor.constraint(equalTo: $0.superview)
            self.underlineWidthConstraint
            $0.heightAnchor.constraint(equalToConstant: 1.5)
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
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            guard let leading = self.underlineLeadingConstraint, let width = self.underlineWidthConstraint else { return }
            leading.constant = view.frame.origin.x
            width.constant = view.frame.width
            
            self.layoutIfNeeded()
        }
        
        // Segment가 변경되면 Publisher에 신호 전달
        NotificationCenter.default.post(
            name: Notification.Name("segmentedControlValueChanged<\(type(of: self.items.first!))>"),
            object: self
        )
        
        return self.selectedSegmentIndex
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomSegmentedControl {
    var publisher: AnyPublisher<T, Never> {
        
        return NotificationCenter.default.publisher(for: Notification.Name("segmentedControlValueChanged<\(type(of: self.items.first!))>"), object: self)
            .compactMap { [weak self] _ in
                guard let self else {
                    return nil
                }
                
                return self.items[self.selectedSegmentIndex]
            }
            .eraseToAnyPublisher()
    }
}
