//
//  UIColor+Extensions.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

extension UIColor {
    static let mainGreen = UIColor(rgb: 0x007778)
    static let disabledGray = UIColor(rgb: 0xD8D8D8)
    
    static let alertButtonGray = UIColor(rgb: 0xF1F1F2)
    static let primaryTeal = UIColor(rgb: 0x009EA0)
    static let inactiveGray = UIColor(rgb: 0xABABAB)
    
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
