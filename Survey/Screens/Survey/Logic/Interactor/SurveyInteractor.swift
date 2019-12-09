//
//  SurveyInteractor.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

final class SurveyInteractor {
    weak var output: SurveyInteractorOutput?
    
    private var service: SurveyService
    
    init(service: SurveyService) {
        self.service = service
    }
    
    deinit {
        print("SurveyInteractor deinit...")
    }
}

//MARK: - SurveyInteractorInteractorInput

extension SurveyInteractor: SurveyInteractorInput {
    
    func setup() {
        loadQuestions()
    }
    
    func loadQuestions() {
        output?.didStartLoading()
        
        weak var weakSelf = self
        
        service.questions()
            .addSuccess { questions in
                let items = questions.map(SurveyQuestionItem.init)
                weakSelf?.output?.didLoadQuestions(items)
        }
        .addFailure { error in
            weakSelf?.output?.didFailLoadingWithError(error)
        }
    }
    
    func submitAnswer(_ answer: AnswerVO) {
        weak var weakSelf = self
        
        service.submitAnswer(answer)
            .addSuccess { value in
                weakSelf?.output?.didSuccessfullySubmitedAnswer(answer)
        }
        .addFailure { error in
            weakSelf?.output?.didFailSubmittingAnswer(answer)
        }
    }
    
    
}

