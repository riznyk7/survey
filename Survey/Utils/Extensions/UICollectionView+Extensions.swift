//
//  UICollectionView+Extensions.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit


extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(withIdentifier identifier: String = T.className, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
    
    func registerCellFromNib(_ CellType: UICollectionViewCell.Type) {
        self.register(CellType.nib, forCellWithReuseIdentifier: CellType.className)
    }
    
    func registerCellClass(_ CellType: UICollectionViewCell.Type) {
        self.register(CellType, forCellWithReuseIdentifier: CellType.className)
    }
}
