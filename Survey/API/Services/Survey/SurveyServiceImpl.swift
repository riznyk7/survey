//
//  SurveyServiceImpl.swift
//  FoldingCell
//
//  Created by Piter Miller on 1/6/19.
//  Copyright © 2019 Yura. All rights reserved.
//

import Foundation

class SurveyServiceImpl: BaseSessionService, SurveyService {
    
    
    deinit {
        print("SurveyServiceImpl deinit...")
    }
    
    //MARK: -
    //MARK: Survey
    
    
    func questions() -> ResultTask<[QuestionVO]> {
        let request = RequestBuilder(method: .get,
                                     path: "questions")
        return arrayTask(request: request)
    }
    
    
    func submitAnswer(_ answer: AnswerVO) -> ResultTask<Bool> {
        let request = RequestBuilder(method: .post,
                                     path: "question/submit",
                                     parameters: answer.toJSON())
        return noContentTask(request: request)
    }
    
}
