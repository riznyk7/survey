//
//  SurveyInteractorTest.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import XCTest
@testable import Survey

class SurveyInteractorTest: XCTestCase {

    var output: FakeSurveyInteractorOutput!
    var interactor: SurveyInteractor!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        output = nil
        interactor = nil
    }
    
    fileprivate func configureObjects(fixtureUrl: URL) {
        let service = SurveyServiceStub(fixtureURL: fixtureUrl)
        
        output = FakeSurveyInteractorOutput()
        interactor = SurveyInteractor(service: service)
        interactor.output = output
    }

}

extension SurveyInteractorTest {

    func test_loading_questions_success() {
        configureObjects(fixtureUrl: FixtureURL.survey.questions_success)
        
        expectUntil (count: 2, completion: { done in
            
            self.output.didStartLoadingCompletion = {
                done()
            }
            
            self.output!.didLoadQuestionsCompletion = { questions in
                guard questions.count == 10 else {
                    XCTFail("should be 10 questions")
                    return
                }
                
                let first = questions[0]
                
                let question = QuestionVO(id: 1,
                                          question: "What is your favourite colour?")
                
                
                let item = SurveyQuestionItem(question: question,
                                              state: .default,
                                              answer: nil)
                
                XCTAssertTrue(item == first, "Object from output differs from expected")
                done()
            }
            self.interactor!.loadQuestions()
            
        })
        
    }
    
    func test_loading_questions_failure() {
        configureObjects(fixtureUrl: FixtureURL.error)
        
        expectUntil (count: 2, completion: { done in
            
            self.output.didStartLoadingCompletion = {
                done()
            }
            
            self.output!.didFailLoadingWithErrorCompletion = { error in
                guard let e = error as? ServerError else {
                    XCTFail("Expected ServerError")
                    return
                }
                
                XCTAssertTrue(e.statusCode == 400, "Expected 400 status code")
                done()
            }
            self.interactor!.loadQuestions()
        })
        
    }
    
    
    
    func test_submit_answer_success() {
        configureObjects(fixtureUrl: FixtureURL.empty)
        
        let answer = AnswerVO(id: 1, answer: "Test answer")
        
        expectUntil { done in
            
            self.output!.didSuccessfullySubmitedAnswerCompletion = { a in
                XCTAssertTrue(answer == a, "Expected different Answer object")
                done()
            }
            
            self.interactor!.submitAnswer(answer)
        }
        
    }
    
    
    func test_submit_answer_failure() {
        configureObjects(fixtureUrl: FixtureURL.error)
        
        let answer = AnswerVO(id: 1, answer: "Test answer")
        
        expectUntil { done in
            
            self.output!.didFailSubmittingAnswerCompletion = { a in
                XCTAssertTrue(answer == a, "Expected different Answer object")
                done()
            }
            
            self.interactor!.submitAnswer(answer)
        }
        
    }
    
}
