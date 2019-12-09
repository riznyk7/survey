//
//  MokingProtocol.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import Alamofire

class MockingURLProtocol: URLProtocol {
    private let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    // MARK: Class Request Methods
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let headers = request.allHTTPHeaderFields else { return request }
        do {
            return try URLEncoding.default.encode(request, with: headers)
        } catch {
            return request
        }
    }
    
    // MARK: Loading Methods
    override func startLoading() {
        if let url = request.url,
            let data = try? Data(contentsOf: url),
            let code = url.statusCodeFromPath,
            let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: "HTTP/1.1", headerFields: cannedHeaders) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}

class MockingSessionManager: SessionManager {
    init() {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral.copy() as! URLSessionConfiguration
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        super.init(configuration: configuration)
    }
}
