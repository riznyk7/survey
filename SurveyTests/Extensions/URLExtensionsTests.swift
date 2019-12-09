//
//  URLExtensions.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

extension URL {
    var statusCodeFromPath: Int? {
        let suffix: Substring = deletingPathExtension().absoluteString.suffix(3)
        return Int(suffix)
    }
}
