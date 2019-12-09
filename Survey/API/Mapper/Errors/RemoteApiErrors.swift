//
//  RemoteApiErrors.swift
//  Survey
//
//  Created by Piter Miller on 9/14/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

extension ServerError {
    
    private static let statusCodeKey = "statusCodeKey"
    
    static func wrongResponseFormat(_ description: String? = nil, statusCode: Int? = nil) -> ServerError {
        let retsultDescription = description ?? "Something went wrong"
        return ServerError(.wrongResponseFormat, userInfo: [NSLocalizedDescriptionKey: retsultDescription,
                                                            statusCodeKey: statusCode as Any])
    }
    
    var statusCode: Int? {
        return self.userInfo[ServerError.statusCodeKey] as? Int
    }
}
