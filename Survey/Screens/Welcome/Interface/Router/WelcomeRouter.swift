//
//  WelcomeRouter.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

final class WelcomeRouter {
    weak var viewController: UIViewController?
    
    
    deinit {
        print("WelcomeRouter deinit...")
    }
}


//MARK: - WelcomeWireframe

extension WelcomeRouter: WelcomeWireframe {
    func showAlertWithError(reason: String) {
        //FIXME: - Need implementation
    }
    
    func showSurvey() {
        let vc: SurveyViewController = UIStoryboard.main.instantiate()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

