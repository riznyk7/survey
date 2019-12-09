//
//  SurveyRouter.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

final class SurveyRouter {
    weak var viewController: UIViewController?
    
    deinit {
        print("SurveyRouter deinit...")
    }
}


//MARK: - SurveyWireframe

extension SurveyRouter: SurveyWireframe {
    
    func showAlertWithError(reason: String) {
        Alert.show(type: .error(title: "Error", message: reason), completion: nil)
    }
}

