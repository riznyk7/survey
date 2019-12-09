//
//  HasProgress.swift
//  Survey
//
//  Created by Piter Miller on 9/14/18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Alamofire

protocol HasProgress {
    func progressHandler(_ block: @escaping (Progress) -> Void)
}

extension UploadRequest: HasProgress {
    func progressHandler(_ block: @escaping (Progress) -> Void) {
        self.uploadProgress(queue: DispatchQueue.main, closure: block)
    }
}
