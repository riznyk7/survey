//
//  AsyncTask.swift
//  Survey
//
//  Created by Piter Miller on 5/30/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

typealias ResultTask<T> = AsyncTask<T, Error>

class AsyncTask<T, E>: Cancellable {
    
    var dataRequest: Cancellable? {
        didSet {
            if let r = dataRequest as? HasProgress {
                r.progressHandler { [weak self] progress in
                    self?.progress(progress)
                }
            }
        }
    }
    
    
    private(set) var isCancelled = SafeBox(false)
    private var isCallbackReturned = SafeBox(false)
    
    private var successPool: [(T) -> Void] = []
    private var failurePool: [(E) -> Void] = []
    private var progressPool: [(Progress) -> ()] = []
    private var completionPool: [(_ cancelled: Bool) -> Void] = []
    
    init(dataRequest: Cancellable? = nil) {
        self.dataRequest = dataRequest
    }
    
    func cancel() {
        isCancelled <- true
        
        dataRequest?.cancel()
        
        completeWithStatus(true)
    }
    
    @discardableResult
    func addSuccess(_ success: @escaping (T) -> Void) -> Self {
        successPool.append(success)
        return self
    }
    
    @discardableResult
    func addFailure(_ failure: @escaping (E) -> Void) -> Self {
        failurePool.append(failure)
        return self
    }
    
    @discardableResult
    func addCompletion(_ completion: @escaping (Bool) -> Void) -> Self {
        completionPool.append(completion)
        return self
    }
    
    @discardableResult
    func addProgress(_ completion: @escaping (Progress) -> Void) -> Self {
        progressPool.append(completion)
        return self
    }
    
    @discardableResult
    func forward(task: AsyncTask<T, E>) -> Self {
        addSuccess(task.success)
        addFailure(task.failure)
        addCompletion(task.completeWithStatus)
        addProgress(task.progress)
        
        task.dataRequest = dataRequest
        
        return self
    }
    
    func success(_ result: T) {
        checkReturnedCallback()
        
        guard isCancelled == false else { return }
        
        for block in successPool {
            guard isCancelled == false else { return }
            
            block(result)
        }
        
        completeWithStatus(isCancelled.value)
    }
    
    func failure(_ error: E) {
        checkReturnedCallback()
        
        guard isCancelled == false else { return }
        
        for block in failurePool {
            guard isCancelled == false else { return }
            
            block(error)
        }
        
        completeWithStatus(isCancelled.value)
    }
    
    func progress(_ progress: Progress) {
        for block in progressPool {
            block(progress)
        }
    }
    
    private func completeWithStatus(_ cancelled: Bool) {
        for block in completionPool {
            block(cancelled)
        }
        
        successPool = []
        failurePool = []
        completionPool = []
    }
    
    private func checkReturnedCallback() {
        assert(isCallbackReturned == false, "Error, calback has already been called")
        isCallbackReturned <- true
    }
}

extension AsyncTask: Hashable {
    var hashValue: Int {
        return unsafeBitCast(self, to: Int.self)
    }
    
    static func ==(a: AsyncTask<T, E>, b: AsyncTask<T, E>) -> Bool {
        return a.hashValue == b.hashValue
    }
}

//MARK: -
//MARK: Async
extension AsyncTask {
    static func async(queue: DispatchQueue = .main, block: @escaping (AsyncTask) -> Void) -> AsyncTask {
        return asyncAfter(deadline: .now(), queue: queue, block: block)
    }
    
    static func asyncAfter(deadline: DispatchTime, queue: DispatchQueue = .main, block: @escaping (AsyncTask) -> Void) -> AsyncTask {
        let task = AsyncTask()
        queue.asyncAfter(deadline: deadline) { block(task) }
        return task
    }
    
    func async(queue: DispatchQueue = .main, block: @escaping (AsyncTask) -> Void) -> AsyncTask {
        return asyncAfter(deadline: .now(), queue: queue, block: block)
    }
    
    func asyncAfter(deadline: DispatchTime, queue: DispatchQueue = .main, block: @escaping (AsyncTask) -> Void) -> AsyncTask {
        queue.asyncAfter(deadline: deadline) { block(self) }
        return self
    }
}


//MARK: -
//MARK: Map functions

extension AsyncTask {
    func map<Result, NewError>(success: @escaping (T) -> Result, failure: @escaping (E) -> NewError) -> AsyncTask<Result, NewError> {
        let task = AsyncTask<Result, NewError>()
        
        self.addSuccess { task.success(success($0)) }
            .addFailure { task.failure(failure($0)) }
            .addProgress(task.progress)
        
        task.dataRequest = dataRequest
        
        return task
    }
    
    func mapSuccess<Result>(_ transform: @escaping (T) -> Result) -> AsyncTask<Result, E> {
        return map(success: transform, failure: identity)
    }
    
    func mapError<NewError>(_ transform: @escaping (E) -> NewError) -> AsyncTask<T, NewError> {
        return map(success: identity, failure: transform)
    }
}
