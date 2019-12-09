//
//  NSLockingExtensions.swift
//  Survey
//
//  Created by Piter Miller on 6/14/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

extension NSLocking {
    func `do`<Result>(action: () -> Result) -> Result {
        lock()
        defer { unlock() }
        
        return action()
    }
}
