//
//  UIView+Extensions.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

let CAAnimationRotate360Key = "360DegreeRotation"

extension UIView {
    
    class func fromNib<T : UIView>() ->T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    public func rotate360Degrees(duration: CFTimeInterval = 1.0, angle: CGFloat = .pi * 2) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = angle
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        self.layer.add(rotateAnimation, forKey: CAAnimationRotate360Key)
    }
    
    public func edges(toView view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate(edgesConstraints(toView: view, insets: insets))
    }
    
    public func center(inView view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public func edgesConstraints(toView view: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
        ]
    }
}
