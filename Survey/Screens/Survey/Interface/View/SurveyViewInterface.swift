//
//  SurveyViewInterface.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

protocol SurveyViewInterface: class {
    
    func showReload()
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func didLoadItems(_ items: [SurveyQuestionCollectionViewCell.DisplayItem])
    func didUpdateItems(_ items: [SurveyQuestionCollectionViewCell.DisplayItem])
}

