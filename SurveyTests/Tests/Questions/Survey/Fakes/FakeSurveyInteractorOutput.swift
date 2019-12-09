//
//  FakeSurveyInteractorOutput.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
@testable import Survey

class FakeSurveyInteractorOutput {
    var didStartLoadingCompletion: () -> Void = { }
    var didSuccessfullySubmitedAnswerCompletion: (AnswerVO) -> () = { _ in }
    var didLoadQuestionsCompletion: ([SurveyQuestionItem]) -> () = { _ in }
    var didFailLoadingWithErrorCompletion: (Error) -> () = { _ in }
    var didFailSubmittingAnswerCompletion: (AnswerVO) -> () = { _ in }
}

extension FakeSurveyInteractorOutput: SurveyInteractorOutput {
    
    func didStartLoading() {
        didStartLoadingCompletion()
    }
    
    func didSuccessfullySubmitedAnswer(_ answer: AnswerVO) {
        didSuccessfullySubmitedAnswerCompletion(answer)
    }
    
    func didLoadQuestions(_ questions: [SurveyQuestionItem]) {
        didLoadQuestionsCompletion(questions)
    }
    
    func didFailLoadingWithError(_ error: Error) {
        didFailLoadingWithErrorCompletion(error)
    }
    
    func didFailSubmittingAnswer(_ answer: AnswerVO) {
        didFailSubmittingAnswerCompletion(answer)
    }
    

}
