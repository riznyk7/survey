//
//  BaseSessionService.swift
//  Survey
//
//  Created by Piter Miller on 6/26/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


protocol ErrorPropagatable {
    static func makeOrPropagateError(_ error: Error) -> Error
}

class BaseSessionService {
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        return SessionManager(configuration: configuration)
    }()
    
    func requestWrapper(_ request: URLRequestConvertible) -> DataRequest {
        return manager.request(request)
    }
}

//MARK: -
//MARK: AsyncTask

extension BaseSessionService {
    func objectTask<T: BaseMappable>(request: URLRequestConvertible, mapContext: MapContext? = nil) -> AsyncTask<T, Error> {
        let task = AsyncTask<T, Error>()
        task.dataRequest = requestWrapper(request).surveyResponse(mapContext: mapContext, completionHandler: task.defaultHandler())
        
        
        return task
    }
    
    func arrayTask<T: BaseMappable>(request: URLRequestConvertible, mapContext: MapContext? = nil) -> AsyncTask<[T], Error> {
        let task = AsyncTask<[T], Error>()
        task.dataRequest = requestWrapper(request).surveyResponseArray(mapContext: mapContext, completionHandler: task.defaultHandler())
        return task
    }
    
    func jsonTask(request: URLRequestConvertible, mapContext: MapContext? = nil) -> AsyncTask<JSON, Error>  {
        let task = AsyncTask<JSON, Error>()
        task.dataRequest = requestWrapper(request).surveyResponseJSON(completionHandler: task.defaultHandler())
        return task
    }
        
    func noContentTask(request: URLRequestConvertible, mapContext: MapContext? = nil) -> AsyncTask<Bool, Error> {
        let task = AsyncTask<Bool, Error>()
        task.dataRequest = requestWrapper(request).surveyResponseNoContent(completionHandler: task.defaultHandler())
        return task
    }
}
