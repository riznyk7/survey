//
//  QuestionsParsingTest.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import XCTest
@testable import Survey


class QuestionsParsingTest: XCTestCase {

    var surveyService: SurveyServiceStub!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        surveyService = nil
        super.tearDown()
    }
    
    private func configureObjects(fixtureURL: URL) {
        let service = SurveyServiceStub(fixtureURL: fixtureURL)
        service.fixtureURL = fixtureURL
        surveyService = service
    }
    
    func test_10_questions_success_parsing() {
        configureObjects(fixtureURL: FixtureURL.survey.questions_success)
        
        expectUntil { done in
            self.surveyService.questions().addSuccess{ questions in
                guard questions.count == 10 else {
                    XCTFail("Should parse 10 questions.")
                    return
                }
                
                XCTAssertEqual(questions[0].id, 1)
                XCTAssertEqual(questions[0].question, "What is your favourite colour?")
            }
            .addFailure { error in
                XCTFail("Should parse 10 questions. Error: \(error.reason)")
            }
            .addCompletion { _ in
                done()
            }
        }
    }
    
    func test_0_questions_success_parsing() {
        configureObjects(fixtureURL: FixtureURL.emptyArray)
        
        expectUntil { done in
            self.surveyService.questions().addSuccess{ questions in
                XCTAssertEqual(questions.count, 0)
            }
            .addFailure { error in
                XCTFail("Should parse 0 questions. Error: \(error.reason)")
            }
            .addCompletion { _ in
                done()
            }
        }
    }
    
    func test_questions_failure_parsing() {
        configureObjects(fixtureURL: FixtureURL.error)
        
        expectUntil { done in
            self.surveyService.questions().addSuccess{ questions in
                XCTFail("Should fail")
            }
            .addFailure { error in
                guard let e = error as? ServerError else {
                    XCTFail("Received not ServerError from API call")
                    return
                }
                XCTAssertTrue(e.statusCode == 400, "Error code should be 400")
            }
            .addCompletion { _ in
                done()
            }
        }
    }
    
    func test_answer_submit_success() {
        configureObjects(fixtureURL: FixtureURL.empty)
        
        let answer = AnswerVO(id: 0, answer: "Test 0")
        
        expectUntil { done in
            self.surveyService.submitAnswer(answer).addSuccess{ _ in
                done()
            }
            .addFailure { error in
                XCTFail("Submit answer call has failed")
            }
        }
    }

}
