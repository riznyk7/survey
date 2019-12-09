//
//  AnswerVO.swift
//  Survey
//
//  Created by Piter Miller on 12/8/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import ObjectMapper

struct AnswerVO: ImmutableMappable, Equatable {
    let id: Int
    let answer: String
    
    init(map: Map) throws {
        self.id = try map.value("id")
        self.answer = try map.value("answer")
    }
    
    init(id: Int, answer: String) {
        self.id = id
        self.answer = answer
    }
}
