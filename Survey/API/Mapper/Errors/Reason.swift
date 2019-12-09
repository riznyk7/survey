//
//  Reason.swift
//  Survey
//
//  Created by Piter Miller on 9/17/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

protocol Reason {
    var reason: String { get }
}

extension Error {
    var reason: String {
        return self.localizedDescription
    }
}
