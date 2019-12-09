//
//  SurveyFixtures.swift
//  SurveyTests
//
//  Created by Yura on 12/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

extension FixtureURL {
    static let survey = SurveyFixtures()
}

class SurveyFixtures: BundleURLProducer {
    fileprivate init() {}
    
    var questions_success: URL { return bundleURL(from: "questions_success_200") }
}
