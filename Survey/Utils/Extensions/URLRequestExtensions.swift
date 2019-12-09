//
//  URLRequestExtensions.swift
//  Survey
//
//  Created by Piter Miller on 8/28/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return 200..<300 ~= statusCode
    }
}
