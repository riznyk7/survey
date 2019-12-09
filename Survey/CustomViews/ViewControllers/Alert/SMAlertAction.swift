//
//  SMAlertAction.swift
//  home
//
//  Created by Piter Miller on 12/19/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit

enum SMAlertActionStyle {
    case gray
    case white
}

final class SMAlertAction {
    
    private var title: String
    private var style: SMAlertActionStyle
    
    var handler: ((SMAlertAction) -> Void)?
    var shouldDismissAlert = true
    
    var enabled: Bool = true {
        didSet {
            button?.isEnabled = enabled
        }
    }
    private(set) var button: UIButton!

    
    init(title: String, style: SMAlertActionStyle, handler: ((SMAlertAction) -> Void)? = nil) {
        self.title = title
        self.handler = handler
        self.style = style
    
        setButton()
    }
    
    private func setButton() {
        button = UIButton()
        button.isEnabled = enabled
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        
        configureButtonHeight()
        configureButtonColors()
        configureButtonShape()
    }
    
    private func configureButtonHeight() {
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    private func configureButtonShape() {
        button.clipsToBounds = true
        button.layer.cornerRadius = 6.0
        switch style {
        case .gray:
            button.backgroundColor = .alertButtonGray
        case .white:
            button.layer.borderWidth = 2.0
            button.layer.borderUIColor = .alertButtonGray
            button.backgroundColor = .white
        }
    }
    
    private func configureButtonColors() {
        let titleColor: UIColor = .primaryTeal
        
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor.withAlphaComponent(0.3), for: .highlighted)
        button.setTitleColor(.inactiveGray, for: .disabled)
        
        switch style {
        case .gray:
            button.backgroundColor = .alertButtonGray
        case .white:
            button.backgroundColor = .white
        }
    }
}


