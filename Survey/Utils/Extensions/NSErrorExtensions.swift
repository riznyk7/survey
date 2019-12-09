//
//  NSErrorExtensions.swift
//  Survey
//
//  Created by Piter Miller on 9/14/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

extension NSError {
    func mapUserInfo(_ transform: (inout [String: Any]) -> Void) -> NSError {
        var userInfo = self.userInfo
        transform(&userInfo)
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
