//
//  Cancellable.swift
//  Survey
//
//  Created by Piter Miller on 3/28/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }
extension DispatchWorkItem: Cancellable { }
