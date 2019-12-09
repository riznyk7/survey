//
//  FixtureURL.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

class FixtureURL: BundleURLProducer {
    static var empty: URL { return self.bundleURL(from: "empty_200") }
    static var emptyArray: URL { return self.bundleURL(from: "empty_array_200") }
    static var error: URL { return self.bundleURL(from: "error_400") }
    
    private init() {}
}
