//
//  ArrayExtensions.swift
//  Survey
//
//  Created by Piter Miller on 9/27/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation

//MARK: - Set methods

extension Array where Element: Hashable {
    func exclude(_ elements: [Element]) -> [Element] {
        let result = Set(self).subtracting(Set(elements))
        return Array(result)
    }
}

