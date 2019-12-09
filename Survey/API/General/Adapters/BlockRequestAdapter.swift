//
//  BlockRequestAdapter.swift
//  Survey
//
//  Created by Piter Miller on 9/26/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Alamofire

class BlockRequestAdapter: RequestAdapter {
    var transform: (URLRequest) -> URLRequest
    
    init(_ transform: @escaping (URLRequest) -> URLRequest) {
        self.transform = transform
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return transform(urlRequest)
    }
}
