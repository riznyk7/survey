//
//  AuthAssembly.swift
//  Survey
//
//  Created by Piter Miller on 11.08.17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Swinject

final class AuthAssembly: Assembly {
    
    func assemble(container: Container) {
        registerCommonProtocols(container)
    }
    
    private func registerCommonProtocols(_ container: Container) {
        container.register(AuthRequestAdapter.self) { r in
            return AuthRequestAdapter()
        }
    }
    
}
