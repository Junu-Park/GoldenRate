//
//  SearchViewCellSkeleton.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import UIKit

final class SearchViewCellSkeleton: BaseCollectionViewCell {
    
    private let symbolImageSkeleton: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 25
        return view
    }()
    private let productNameSkeleton: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    private let bankNameSkeleton: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    private let baseRateSkeleton: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    private let maxRateSkeleton: UIView = {
        let view = UIView()
        view.backgroundColor = .defaultGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    private var animationLayer: CAGradientLayer?
    
    private var isActive: Bool = false
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if self.isActive {
            self.start()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 컨텐츠뷰 크기가 잡힌 후에, 애니메이션 레이어 크기 동일하게 설정
        self.animationLayer?.frame = self.contentView.bounds
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews(self.symbolImageSkeleton, self.productNameSkeleton, self.bankNameSkeleton, self.baseRateSkeleton, self.maxRateSkeleton)
    }
    
    override func configureLayout() {
        
        self.symbolImageSkeleton.setConstraints {
            $0.leadingAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.centerYAnchor.constraint(equalTo: $0.superview)
            $0.widthAnchor.constraint(equalToConstant: 50)
            $0.heightAnchor.constraint(equalToConstant: 50)
        }
        
        self.productNameSkeleton.setConstraints {
            $0.topAnchor.constraint(equalTo: $0.superview, constant: 16)
            $0.leadingAnchor.constraint(equalTo: self.symbolImageSkeleton.trailingAnchor, constant: 8)
            $0.widthAnchor.constraint(equalToConstant: 180)
            $0.heightAnchor.constraint(equalToConstant: 20)
        }
        
        self.bankNameSkeleton.setConstraints {
            $0.topAnchor.constraint(equalTo: self.productNameSkeleton.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.symbolImageSkeleton.trailingAnchor, constant: 8)
            $0.widthAnchor.constraint(equalToConstant: 120)
            $0.heightAnchor.constraint(equalToConstant: 18)
        }
        
        self.baseRateSkeleton.setConstraints {
            $0.topAnchor.constraint(equalTo: self.bankNameSkeleton.bottomAnchor, constant: 8)
            $0.leadingAnchor.constraint(equalTo: self.symbolImageSkeleton.trailingAnchor, constant: 8)
            $0.bottomAnchor.constraint(equalTo: $0.superview, constant: -16)
            $0.widthAnchor.constraint(equalToConstant: 100)
            $0.heightAnchor.constraint(equalToConstant: 18)
        }
        
        self.maxRateSkeleton.setConstraints {
            $0.trailingAnchor.constraint(equalTo: $0.superview, constant: -16)
            $0.bottomAnchor.constraint(equalTo: $0.superview, constant: -16)
            $0.widthAnchor.constraint(equalToConstant: 120)
            $0.heightAnchor.constraint(equalToConstant: 20)
        }
    }
    
    override func configureView() {
        self.setShadowBorder()
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .defaultBackground
    }
    
    private func getAnimationLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let lightColor = UIColor.defaultGray.withAlphaComponent(0.1).cgColor
        let darkColor = UIColor.defaultGray.withAlphaComponent(0.3).cgColor
        layer.colors = [lightColor, darkColor, lightColor]
        layer.locations = [0, 0.5, 1]
        
        return layer
    }
    
    private func getAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        
        return animation
    }
    
    func start() {
        self.animationLayer?.removeFromSuperlayer()
        
        self.isActive = true
        
        self.animationLayer = self.getAnimationLayer()
        self.animationLayer?.frame = self.contentView.bounds

        guard let layer = self.animationLayer else {
            return
        }
        layer.add(self.getAnimation(), forKey: "shimmerAnimation")
        self.contentView.layer.insertSublayer(layer, at: 0)
    }
    
    func stop() {
        self.isActive = false
        
        self.animationLayer?.removeFromSuperlayer()
        self.animationLayer = nil
    }
}
