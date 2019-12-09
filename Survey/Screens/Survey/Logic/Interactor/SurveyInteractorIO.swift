//
//  SurveyInteractorIO.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

protocol SurveyInteractorInput {
    var output: SurveyInteractorOutput? { get set }
    func setup()
    func submitAnswer(_ answer: AnswerVO)
    
}

protocol SurveyInteractorOutput: class {
    func didStartLoading()
    func didSuccessfullySubmitedAnswer(_ answer: AnswerVO)
    func didLoadQuestions(_ questions: [SurveyQuestionItem])
    func didFailLoadingWithError(_ error: Error)
    func didFailSubmittingAnswer(_ answer: AnswerVO)
}
