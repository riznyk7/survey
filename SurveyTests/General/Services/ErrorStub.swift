//
//  ErrorStub.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
@testable import Survey

struct ErrorStub: Error, ErrorPropagatable {
    var reason: String
    
    static func makeOrPropagateError(_ error: Error) -> Error {
        return ErrorStub(reason: error.localizedDescription)
    }
}
