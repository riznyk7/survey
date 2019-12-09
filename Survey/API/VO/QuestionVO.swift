//
//  QuestionVO.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import ObjectMapper

struct QuestionVO: ImmutableMappable, Equatable {
    let id: Int
    let question: String
    
    init(map: Map) throws {
        self.id = try map.value("id")
        self.question = try map.value("question")
    }
    
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}
