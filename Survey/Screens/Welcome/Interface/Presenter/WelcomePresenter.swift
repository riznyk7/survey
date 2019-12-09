//
//  WelcomePresenter.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

final class WelcomePresenter {
    private unowned let view: WelcomeViewInterface
    private let router: WelcomeWireframe
    
    init(view: WelcomeViewInterface,
         router: WelcomeWireframe) {
        
        self.view = view
        self.router = router
    }
    
    deinit {
        print("WelcomePresenter deinit...")
    }
}

//MARK: -  WelcomeModuleInterface

extension WelcomePresenter: WelcomeModuleInterface {
    
    func setup() {
        
    }
    
    func didTouchNextButton() {
        router.showSurvey()
    }
    
}

