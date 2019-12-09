//
//  SMAlertView.swift
//  Survey
//
//  Created by Piter Miller on 6/7/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

final class SMAlertView: UIView {
    
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var buttonsStack: UIStackView!
    @IBOutlet var buttonsBackgroundView: UIView!
    @IBOutlet var alertView: UIView!
    @IBOutlet var activityIndicator: CircleRotatingLoader!
    
    class func view() -> SMAlertView {
        let view = Bundle.main.loadNibNamed("SMAlertView", owner: nil, options: nil)!.first as! SMAlertView
        return view
    }
    
    override func awakeFromNib() { }
}
