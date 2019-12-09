//
//  ApiTaskTest.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import XCTest
@testable import Survey
import Alamofire

class ApiTaskTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_apiTask_equatable() {
        let task1 = AsyncTask<Bool, TestError>()
        let task2 = AsyncTask<Bool, TestError>()
        let task3 = task1
        
        XCTAssertTrue(task1 != task2)
        XCTAssertTrue(task1 == task3)
    }
    
    func test_apiTask_progress() {
        func progress(_ val: Double) -> Progress {
            let p = Progress(totalUnitCount: 100)
            p.completedUnitCount = Int64(val*100)
            return p
        }
        
        let task = AsyncTask<Bool, TestError>()
        let progressRequest = HasProgressMock()
        
        task.dataRequest = progressRequest
        
        var progressValues: [Double] = []
        
        task.addProgress { p in
            progressValues.append(p.fractionCompleted)
        }
        
        progressRequest.handler(progress(0.3))
        progressRequest.handler(progress(0.5))
        progressRequest.handler(progress(1.0))
        
        guard progressValues.count == 3 else {
            XCTFail("should be 3 progress updates")
            return
        }
        
        XCTAssertTrue(progressValues[0] == 0.3)
        XCTAssertTrue(progressValues[1] == 0.5)
        XCTAssertTrue(progressValues[2] == 1.0)
    }
    
    func test_apiTask_forward() {
        let task1 = AsyncTask<Double, TestError>()
        let task2 = AsyncTask<Double, TestError>()
        
        let task3 = AsyncTask<Double, TestError>()
        let task4 = AsyncTask<Double, TestError>()
        
        var value: Double?
        var error: String?
        var completion = false
        
        task1.forward(task: task2)
        task3.forward(task: task4)
        
        task2
            .addSuccess { value = $0 }
            .addCompletion { _ in completion = true }
                
        task4.addFailure { error = $0.value }
        
        task1.success(5)
        task3.failure(TestError("Error value"))
        
        
        XCTAssertTrue(value == 5)
        XCTAssertTrue(error == "Error value")
        XCTAssertTrue(completion)
    }
    
    func test_apiTask_static_async() {
        var value: String?
        
        expectUntil { done in
            AsyncTask<String, TestError>.async { $0.success("Some value") }
                .addSuccess { value = $0 }
                .addCompletion { _ in 
                    XCTAssertTrue(value == "Some value")
                    done()
                }
        }
    }
    
    func test_apiTask_async() {
        var value: String?
        let task = AsyncTask<String, TestError>()
        
        expectUntil { done in
            task.async { $0.success("Some value") }
                .addSuccess { value = $0 }
                .addCompletion { _ in 
                    XCTAssertTrue(value == "Some value")
                    done()
            }
        }
    }
    
    func test_apiTask_cancel() {
        let requestMock = CancellableMock()
        let task = AsyncTask<String, TestError>()
        var taskCancelled = false
        
        task.dataRequest = requestMock
        task
            .addSuccess { _ in XCTFail("shouldn't be called") }
            .addFailure { _ in XCTFail("shouldn't be called") }
            .addCompletion { cancelled in taskCancelled = cancelled }
        
        
        XCTAssertTrue(requestMock.isCancelled == false)
        task.cancel()
        XCTAssertTrue(requestMock.isCancelled)
        XCTAssertTrue(taskCancelled)
    }
    
    func test_apiTask_mapSuccess() {
        let task = AsyncTask<String, TestError>()
        var result = 1
        let mappedTask = task.mapSuccess { Int($0)! }
        
        mappedTask.addSuccess { result = $0 + 2 }
        
        
        task.success("1")
        XCTAssertEqual(result, 3)
    }
    
    func test_apiTask_mapError() {
        let task = AsyncTask<String, TestError>()
        var result: String?
        let mappedTask = task.mapError { _ in TestError("NewError") }
        
        mappedTask.addFailure { result = $0.value }
        
        
        task.failure(TestError("OldError"))
        XCTAssertEqual(result, "NewError")
    }
}

fileprivate struct TestError: Error {
    var value: String?
    
    init(_ value: String?) {
        self.value = value
    }
}

fileprivate class CancellableMock: Cancellable {
    var isCancelled = false
    
    func cancel() {
        isCancelled = true
    }
}

fileprivate class HasProgressMock: HasProgress, Cancellable {
    var handler: (Progress) -> Void = { _ in }
    
    func cancel() {
    }
    
    func progressHandler(_ block: @escaping (Progress) -> Void) {
        handler = block
    }
}
