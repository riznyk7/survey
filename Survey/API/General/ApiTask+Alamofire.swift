//
//  AsyncTask+Alamofire.swift
//  Survey
//
//  Created by Piter Miller on 9/14/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Alamofire

extension AsyncTask where E == Error {
    func defaultHandler() -> (DataResponse<T>) -> Void {
        return { response in
            switch response.result {
            case .failure(let error):
                self.failure(error)
                
            case .success(let value):
                self.success(value)
            }
        }
    }
}

extension DataRequest: Cancellable { }

