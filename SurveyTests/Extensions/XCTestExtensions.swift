
//
//  XCTestExtentions.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func expectUntil(_ description: String? = nil, timeout: TimeInterval? = nil, count: Int = 1, completion: (@escaping () -> Void) -> Void) {
        weak var done = expectation(description: description ?? "")
        var doneCount = 0
        
        completion({
            doneCount += 1
            guard let promise = done, doneCount >= count else { return }
            promise.fulfill()
        })
        
        waitForExpectations(timeout: timeout ?? 1.0) { error in
            if let e = error {
                XCTFail("\(String(describing: done)) - \(e.localizedDescription)")
            }
        }
    }
}

extension XCTestCase: BundleURLProducer {}
