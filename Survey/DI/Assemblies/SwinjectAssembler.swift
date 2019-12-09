//
//  SwinjectAssembler.swift
//  Survey
//
//  Created by Piter Miller on 11.08.17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class SwinjectAssembler {
    private let assembler: Assembler
    
    init() {
        let container = SwinjectStoryboard.defaultContainer
        Container.loggingFunction = nil
        
        let assemblies: [Assembly] = [
            AuthAssembly(),
            SurveyAssembly()
        ]
        
        assembler = Assembler(assemblies, container: container)
    }
}
