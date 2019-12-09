//
//  AuthRequestAdapter.swift
//  Survey
//
//  Created by Piter Miller on 9/22/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Alamofire

class AuthRequestAdapter: RequestAdapter {
    
    init() {
        
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var resultRequest = urlRequest
        var headers = urlRequest.allHTTPHeaderFields ?? [:]
        
        
//        headers = defaultHeaders + headers
//        headers = ["":""] + headers
        resultRequest.allHTTPHeaderFields = headers
        return resultRequest
    }
}
