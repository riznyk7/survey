//
//  CALayer+Extensions.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

extension CALayer {
    
    var borderUIColor: UIColor? {
        set { self.borderColor = newValue?.cgColor }
        get {
            guard let color = self.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
