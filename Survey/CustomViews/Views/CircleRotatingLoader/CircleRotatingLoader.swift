//
//  CircleLoader.swift
//  Survey
//
//  Created by Piter Miller on 15.01.18.
//  Copyright © 2018 home. All rights reserved.
//

import UIKit

struct CircleRotatingLoaderConfig {
    
    enum CircleLoaderImage {
        case greenLoader
        
        var image: UIImage {
            switch self {
            case .greenLoader: return #imageLiteral(resourceName: "circular_loader")
            }
        }
    }
    
    enum PresetConfig {
        case `default`
        case fast
    }
    
    var loaderImage: CircleLoaderImage
    var oneSpinAngle: CGFloat
    var oneSpinDuration: Double
    var frame: CGRect
    
    private static let fastConfig = CircleRotatingLoaderConfig(oneSpinDuration: 0.3)
    private static let defaultConfig = CircleRotatingLoaderConfig(oneSpinDuration: 1.0)
    
    init(loaderImage: CircleLoaderImage, oneSpinAngle: CGFloat, oneSpinDuration: Double, frame: CGRect) {
        self.loaderImage = loaderImage
        self.oneSpinAngle = oneSpinAngle
        self.oneSpinDuration = oneSpinDuration
        self.frame = frame
    }
    
    init(type: PresetConfig) {
        switch type {
        case .`default`:
            self = .defaultConfig
        case .fast:
            self = .fastConfig
        }
    }
    
    init(oneSpinDuration: Double) {
        self = CircleRotatingLoaderConfig(loaderImage: .greenLoader, oneSpinAngle: 2 * .pi, oneSpinDuration: oneSpinDuration, frame: CGRect(x: 0.0, y: 0.0, width: 32.0, height: 32.0))
    }
    
    init() {
        self = CircleRotatingLoaderConfig(loaderImage: .greenLoader, oneSpinAngle: 2 * .pi, oneSpinDuration: 1.0, frame: CGRect(x: 0.0, y: 0.0, width: 32.0, height: 32.0))
    }
    
}

class CircleRotatingLoader: UIView {
    
    private var loaderImageView: UIView!
    private var config: CircleRotatingLoaderConfig
    private var isAnimating: Bool = false
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        startLoadingAnimationIfNeeded()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        startLoadingAnimationIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        config = CircleRotatingLoaderConfig()
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        config = CircleRotatingLoaderConfig()
        super.init(frame: frame)
        setup()
    }
    
    init(config: CircleRotatingLoaderConfig = CircleRotatingLoaderConfig()) {
        self.config = config
        super.init(frame: config.frame)
        setup()
    }
    
    func startLoadingAnimationIfNeeded() {
        if isAnimating {
            startAnimation()
        }
    }
    
    func setupWithConfig(_ config: CircleRotatingLoaderConfig) {
        self.config = config
        clearView()
        setup()
    }
    
    func startAnimation() {
        if layer.animation(forKey: CAAnimationRotate360Key) == nil || !isAnimating {
            isAnimating = true
            UIView.animate(withDuration: config.oneSpinDuration) {
                self.alpha = 1.0
            }
            performLoadingAnimation()
        }
    }
    
    func stopAnimation(completion: (() -> Void)? = nil) {
        guard isAnimating else { return }
        isAnimating = false
        performStopLoadingAnimation(completion: completion)
    }
    
    private func clearView() {
        loaderImageView.removeFromSuperview()
    }
    
    private func performLoadingAnimation() {
        rotate360Degrees(duration: config.oneSpinDuration, angle: config.oneSpinAngle)
    }
    
    private func performStopLoadingAnimation(completion: (() -> Void)?) {
        UIView.animate(withDuration: config.oneSpinDuration, animations: {
            self.alpha = 0.0
        }) { complete in
            self.layer.removeAllAnimations()
            completion?()
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        loaderImageView = UIImageView(image: config.loaderImage.image)
        loaderImageView.contentMode = .scaleAspectFill
        
        addSubview(loaderImageView)
        
        let centerXConstraint = loaderImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerXConstraint.isActive = true
        centerXConstraint.priority = UILayoutPriority(999)
        
        loaderImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        loaderImageView.heightAnchor.constraint(equalToConstant: config.frame.height).isActive = true
        loaderImageView.widthAnchor.constraint(equalToConstant: config.frame.width).isActive = true
        
        self.alpha = 0.0
    }
    
}
