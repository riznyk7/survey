//
//  SurveyQuestionItem.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation


struct SurveyQuestionItem: Equatable {
    
    var question: QuestionVO
    var state: State
    var answer: Answer?
    
    init(question: QuestionVO) {
        self.question = question
        self.state = .default
    }
    
    init(question: QuestionVO, state: State, answer: Answer?) {
        self.question = question
        self.state = state
        self.answer = answer
    }
    
}

extension SurveyQuestionItem {
    
    struct Answer: Equatable {
        var text: String
    }
    
    enum State {
        case submitted
        case loading
        case failed
        case `default`
    }
    
}

extension SurveyQuestionItem {
    
    var toAnswerVO: AnswerVO? {
        guard let answer = answer?.text else { return nil }
        return AnswerVO(id: question.id,
                        answer: answer)
    }
}
