//
//  NSObjectExtensions.swift
//  FoldingCell
//
//  Created by Piter Miller on 12/2/18.
//  Copyright © 2018 Yura. All rights reserved.
//

import UIKit


extension NSObject {
    
    static var nib: UINib? {
        return UINib(nibName: className, bundle: nil)
    }
    
    var className: String {
        return type(of: self).className
    }
    
    class var className: String {
        let result: String = String(describing: self).components(separatedBy: ".").last!
        return result
    }
}
