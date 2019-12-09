//
//  BundleURLProducer.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

protocol BundleURLProducer: class {
}

extension BundleURLProducer {
    func bundleURL(from name: String, fileExtension: String = "json") -> URL {
        return Bundle(for: type(of: self)).url(forResource: name, withExtension: fileExtension)!
    }
    
    static func bundleURL(from name: String, fileExtension: String = "json") -> URL {
        return Bundle(for: self).url(forResource: name, withExtension: fileExtension)!
    }
}
