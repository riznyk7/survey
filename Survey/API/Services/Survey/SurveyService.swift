//
//  SurveyService.swift
//  FoldingCell
//
//  Created by Piter Miller on 1/6/19.
//  Copyright © 2019 Yura. All rights reserved.
//

import Foundation

protocol SurveyService {
    func questions() -> ResultTask<[QuestionVO]>
    func submitAnswer(_ answer: AnswerVO) -> ResultTask<Bool>
}
