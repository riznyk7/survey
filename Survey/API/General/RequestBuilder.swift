//
//  RequestBuilder.swift
//  Survey
//
//  Created by Piter Miller on 7/12/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Alamofire

struct RequestBuilder: BaseServiceRequestBuilderProtocol, URLRequestConvertible, Then {
    var route: (method: Alamofire.HTTPMethod, path: String, parameters: JSON?)!
    var headers: [String: String]?
    
    init(headers: [String: String]? = nil) {
        self.headers = headers
    }
    
    init(headers: [String: String]? = nil, route: (method: Alamofire.HTTPMethod, path: String, parameters: JSON?)? = nil) {
        self.headers = headers
        self.route = route
    }
    
    init(method: Alamofire.HTTPMethod = .get, path: String, parameters: JSON? = nil) {
        self.init(headers: nil, route: (method, path, parameters))
    }
}
