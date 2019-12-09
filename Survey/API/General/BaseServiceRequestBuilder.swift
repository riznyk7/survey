//
//  BaseService.swift
//  Survey
//
//  Created by Piter Miller on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseServiceRequestBuilderProtocol {
    static var baseURL: URL { get }
    
    var route: (method: Alamofire.HTTPMethod, path: String, parameters: JSON?)! { get }
    var headers: [String: String]? { get set }
 }

extension BaseServiceRequestBuilderProtocol {
    static var baseURL: URL {
        let string: String = Bundle.main.infoDictionary!["API_SERVER"] as! String
        return URL(string: string)!
    }
    
    var url: URL {
        if let pathString = route.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: pathString, relativeTo: Self.baseURL)!
        } else {
            assert(false, "something wrong with path")
            return Self.baseURL
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        
        headers?.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return try URLEncoding.default.encode(request, with: route.parameters)
    }
}
