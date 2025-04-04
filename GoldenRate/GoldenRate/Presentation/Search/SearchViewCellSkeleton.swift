//
//  SearchViewCellSkeleton.swift
//  GoldenRate
//
//  Created by 박준우 on 4/4/25.
//

import UIKit

import SnapKit

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
        
        // 애니메이션 레이어 크기를 컨텐츠뷰 크기에 맞추기
        self.animationLayer?.frame = self.contentView.bounds
    }
    
    override func configureHierarchy() {
        self.contentView.addSubviews(self.symbolImageSkeleton, self.productNameSkeleton, self.bankNameSkeleton, self.baseRateSkeleton, self.maxRateSkeleton)
    }
    
    override func configureLayout() {
        
        self.symbolImageSkeleton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        self.productNameSkeleton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalTo(self.symbolImageSkeleton.snp.trailing).offset(8)
            $0.width.equalTo(180)
            $0.height.equalTo(20)
        }
        
        self.bankNameSkeleton.snp.makeConstraints {
            $0.top.equalTo(self.productNameSkeleton.snp.bottom).offset(8)
            $0.leading.equalTo(self.symbolImageSkeleton.snp.trailing).offset(8)
            $0.width.equalTo(120)
            $0.height.equalTo(18)
        }
        
        self.baseRateSkeleton.snp.makeConstraints {
            $0.top.equalTo(self.bankNameSkeleton.snp.bottom).offset(8)
            $0.leading.equalTo(self.symbolImageSkeleton.snp.trailing).offset(8)
            $0.width.equalTo(100)
            $0.height.equalTo(18)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        self.maxRateSkeleton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(120)
            $0.height.equalTo(20)
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
