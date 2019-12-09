//
//  SurveyObjectMapper.swift
//  Survey
//
//  Created by Piter Miller on 5/30/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias JSON = [String: Any]

extension DataRequest {
    
    private static func checkResponseForErrorsWith(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if response?.isSuccess == true {
            return nil
        }
        
        let extractedError = getInternalErrorFrom(request: request, response: response, data: data, error: error)
        
        return extractedError
    }
    
    private static func getInternalErrorFrom(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Error {
        return ServerError.wrongResponseFormat(statusCode: response?.statusCode)
    }
    
    private static func transformError(_ error: Error) -> Error {
        switch error {
        case URLError.notConnectedToInternet:
            return (error as NSError).mapUserInfo { userInfo in
                let description = "Not connected to Internet"
                userInfo[NSLocalizedDescriptionKey] = description
            }
            
        default:
            break
        }
        
        return error
    }
    
    private static func getJSONFrom<T>(request: URLRequest?, response: HTTPURLResponse?, data: Data?) -> T? {
        let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
        return jsonResponseSerializer.serializeResponse(request, response, data, nil).value as? T
    }
    
    //MARK: -
    //MARK: Serializers
    
    private static func arraySerializer<T: BaseMappable>(context: MapContext? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            
            data.flatMap { String(data: $0,encoding: .utf8 ) }
                .map { printRequest(request!.description, response: $0) }
            
            if let serverError = checkResponseForErrorsWith(request: request, response: response, data: data, error: error) {
                return .failure(serverError)
            }
            
            let json: [JSON]? = getJSONFrom(request: request, response: response, data: data)
            
            guard let dataResponse = Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: json) else {
                return .failure(serializationError)
            }
            
            return .success(dataResponse)
        }
    }
    
    private static func objectSerializer<T: BaseMappable>(context: MapContext? = nil) -> DataResponseSerializer<T> {
        
        return DataResponseSerializer { request, response, data, error in
            
            data.flatMap { String(data: $0,encoding: .utf8 ) }
                .map { printRequest(request!.description, response: $0) }
            
            
            if let serverError = checkResponseForErrorsWith(request: request, response: response, data: data, error: error) {
                return .failure(serverError)
            }
            
            let json: JSON? = getJSONFrom(request: request, response: response, data: data)
            
            guard let dataResponse = Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: json) else {
                return .failure(serializationError)
            }
            
            return .success(dataResponse)
        }
    }
    
    private static func noContentSerializer() -> DataResponseSerializer<Bool> {
        return DataResponseSerializer { request, response, data, error in
            
            data.flatMap { String(data: $0,encoding: .utf8 ) }
                .map { printRequest(request!.description, response: $0) }
            
            if response?.statusCode == 204 {
                return .success(true)
            }
            
            if let serverError = checkResponseForErrorsWith(request: request, response: response, data: data, error: error) {
                return .failure(serverError)
            }
            
            return .success(false)
        }
    }
    
    private static func jsonSerializer<T>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            
            data.flatMap { String(data: $0,encoding: .utf8 ) }
                .map { printRequest(request!.description, response: $0) }
            
            if let serverError = checkResponseForErrorsWith(request: request, response: response, data: data, error: error) {
                return .failure(serverError)
            }
            
            let json: T? = getJSONFrom(request: request, response: response, data: data)
            
            guard let dataResponse = json else {
                return .failure(serializationError)
            }
            
            return .success(dataResponse)
        }
    }
    
    
    
    //MARK: -
    //MARK: Helpers
    
    private static func printRequest(_ request: String, response: String) {
        let responseString = "\n🔻🔺 REST: \(Date()):\nRequest: \(request) \nResponse:\n\(response)\n"
        print(responseString)
    }
    
    private static var serializationError: ServerError {
        let failureReason = "Something went wrong."
        return ServerError.wrongResponseFormat(failureReason)
    }
    
    //MARK: -
    //MARK: Responses
    
    @discardableResult
    func surveyResponse<T>(mapContext: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self where T: BaseMappable {
        return response(queue: nil, responseSerializer: DataRequest.objectSerializer(context: mapContext), completionHandler: completionHandler)
    }
    
    @discardableResult
    func surveyResponseArray<T>(mapContext: MapContext? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self where T: BaseMappable {
        return response(queue: nil, responseSerializer: DataRequest.arraySerializer(context: mapContext), completionHandler: completionHandler)
    }
    
    @discardableResult
    func surveyResponseJSON<T>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: nil, responseSerializer: DataRequest.jsonSerializer(), completionHandler: completionHandler)
    }
    
    
    @discardableResult
    func surveyResponseNoContent(completionHandler: @escaping(Alamofire.DataResponse<Bool>) -> Void) -> Self {
        return response(queue: nil, responseSerializer: DataRequest.noContentSerializer(), completionHandler: completionHandler)
    }
}
