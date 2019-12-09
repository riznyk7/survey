//
//  SurveyPresenter.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

final class SurveyPresenter {
    private unowned let view: SurveyViewInterface
    private let interactor: SurveyInteractorInput
    private let router: SurveyWireframe
    private var questionItems: [SurveyQuestionItem]
    
    init(view: SurveyViewInterface,
         interactor: SurveyInteractorInput,
         router: SurveyWireframe) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.questionItems = []
    }
    
    deinit {
        print("SurveyPresenter deinit...")
    }
}

//MARK: -  SurveyModuleInterface

extension SurveyPresenter: SurveyModuleInterface {
    func setup() {
        interactor.setup()
    }
    
    func submittedQuestionsCount() -> Int {
        return questionItems.filter{ $0.state == .submitted }.count
    }
}

//MARK: -  SurveyInteractorOutput

extension SurveyPresenter: SurveyInteractorOutput {
    
    func didSuccessfullySubmitedAnswer(_ answer: AnswerVO) {
        guard let index = questionItems.firstIndex(where: { $0.question.id == answer.id }) else { return }
        questionItems[index].state = .submitted
        updateDisplayItems()
    }
    
    func didStartLoading() {
        view.startLoadingAnimation()
    }
    
    func didLoadQuestions(_ questions: [SurveyQuestionItem]) {
        questionItems = questions
        
        let displayItems = displayItemsForItems(questions)
        view.didLoadItems(displayItems)
        
        view.stopLoadingAnimation()
    }
    
    private func displayItemsForItems(_ items: [SurveyQuestionItem]) -> [SurveyQuestionCollectionViewCell.DisplayItem] {
        weak var weak = self
        
        return questionItems.enumerated().map { (item) in
            return SurveyQuestionCollectionViewCell.DisplayItem(item: item.element,
                                                                onButtonSelect: {
                                                                    guard let strongSelf = weak,
                                                                        let answer = strongSelf.questionItems[item.offset].toAnswerVO else { return }
                                                                    strongSelf.questionItems[item.offset].state = .loading
                                                                    strongSelf.updateDisplayItems()
                                                                    strongSelf.interactor.submitAnswer(answer)
            },
                                                         onTextChange: { text in
                                                            weak?.questionItems[item.offset].answer = text.map { SurveyQuestionItem.Answer(text: $0) }
                                                            weak?.updateDisplayItems()
            })
        }
    }
    
    private func updateDisplayItems() {
        let displayItems = displayItemsForItems(questionItems)
        
        view.didUpdateItems(displayItems)
    }
    
    func didFailLoadingWithError(_ error: Error) {
        router.showAlertWithError(reason: error.reason)
        view.showReload()
    }
    
    func didFailSubmittingAnswer(_ answer: AnswerVO) {
        guard let index = questionItems.firstIndex(where: { $0.question.id == answer.id }) else { return }
        questionItems[index].state = .failed
        updateDisplayItems()
    }
}


