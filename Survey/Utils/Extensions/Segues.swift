//
//  Segues.swift
//  Survey
//
//  Created by Piter Miller on 5/24/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import UIKit
import SwinjectStoryboard

protocol HasIdentifier {
    static var identifier: String { get }
}

extension UIViewController: HasIdentifier {
    static var identifier: String {
        return className
    }
}

extension UIStoryboard {
    
    static var main: SwinjectStoryboard {
        return createStoryboard(name: "Main")
    }
    
    
    private static func createStoryboard(name: String) -> SwinjectStoryboard {
        return SwinjectStoryboard.create(
            name: name, bundle: Bundle.main, container: SwinjectStoryboard.defaultContainer)
    }
}

extension SwinjectStoryboard {
    
    func instantiate<T: UIViewController> (identifier: String = T.className) -> T {
        return instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func instantiate<T: UIViewController, Arg> (identifier: String = T.className, arg: Arg) -> T {
        return instantiateViewController(withIdentifier: identifier, arg: arg) as! T
    }
    
    func instantiate<T: UIViewController, Arg1, Arg2> (identifier: String = T.className, arg1: Arg1, arg2: Arg2) -> T {
        return instantiateViewController(withIdentifier: identifier, arg1: arg1, arg2: arg2) as! T
    }
    
    func instantiate<T: UIViewController, Arg1, Arg2, Arg3> (identifier: String = T.className, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> T {
        return instantiateViewController(withIdentifier: identifier, arg1: arg1, arg2: arg2, arg3: arg3) as! T
    }
}
