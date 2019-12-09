//
//  SurveyServiceStub.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import Alamofire
@testable import Survey

class SurveyServiceStub: SurveyService {
    
    var fixtureURL: URL
    
    let fakeManager = MockingSessionManager()
    
    init(fixtureURL: URL) {
        self.fixtureURL = fixtureURL
    }
    
    
    func questions() -> ResultTask<[QuestionVO]> {
        let task = ResultTask<[QuestionVO]>()
        
        fakeManager.request(fixtureURL).surveyResponseArray(completionHandler: task.defaultHandler())
        
        return task
    }
    
    func submitAnswer(_ answer: AnswerVO) -> ResultTask<Bool> {
        let task = ResultTask<Bool>()
        
        fakeManager.request(fixtureURL).surveyResponseNoContent(completionHandler: task.defaultHandler())
        return task
    }
    
}
