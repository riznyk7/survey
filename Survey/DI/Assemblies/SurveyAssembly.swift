//
//  MarketplaceAssembly.swift
//  Survey
//
//  Created by Piter Miller on 19.02.18.
//  Copyright © 2018 home. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class SurveyAssembly: Assembly {
    
    func assemble(container: Container) {
        [
            registerCommonProtocols,
            registerSurveyViewController,
            registerWelcomeViewController
        ]
        .forEach { $0(container) }
        
    }
    
    private func registerCommonProtocols(in container: Container) {
        container.register(SurveyService.self, factory: { r in
            let service = SurveyServiceImpl()
            service.manager.adapter = r.resolve(AuthRequestAdapter.self)!
            return service
        })
        
    }
    
    
    private func registerWelcomeViewController(container: Container) {
        container.storyboardInitCompleted(WelcomeViewController.self) { (r, c) in
            let router = WelcomeRouter()
            let presenter = WelcomePresenter(view: c,
                                             router: router)
            router.viewController = c
            c.presenter = presenter
        }
    }
    
    
    private func registerSurveyViewController(container: Container) {
        container.storyboardInitCompleted(SurveyViewController.self) { (r, c) in
            let homeService = r.resolve(SurveyService.self)!
            let router = SurveyRouter()
            let interactor = SurveyInteractor(service: homeService)
            let presenter = SurveyPresenter(view: c,
                                            interactor: interactor,
                                            router: router)
            router.viewController = c
            interactor.output = presenter
            c.presenter = presenter
        }
    }
    
}
