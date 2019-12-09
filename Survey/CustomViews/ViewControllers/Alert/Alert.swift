//
//  Alert.swift
//  Survey
//
//  Created by Piter Miller on 6/7/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

final class Alert {
    enum AlertType {
        case progress
        case warning(title: String?, message: String?)
        case error(title: String, message: String?)
        case success(title: String?, message: String?)
    }
    
    @discardableResult
    class func show(type: AlertType, completion: ((SMAlertAction) -> Void)? = nil) -> SMAlertController? {
        let alertView = alert(forType: type, completion: completion)
        alertView?.show()
        return alertView
    }
    
    private  class func alert(forType type: AlertType, completion: ((SMAlertAction) -> Void)? = nil) -> SMAlertController? {
        let alert: SMAlertController?
        
        switch type {
        case .progress:
            alert = SMAlertController(title: "Loading", message: nil, type: .progress)
        case .warning(let title, let message):
            alert = SMAlertController(title: title, message: message, type: .warning)
            let action = SMAlertAction(title: "OK", style: .gray, handler: completion)
            alert?.addAction(action: action)
        case .error(let title, let message):
            alert = SMAlertController(title: title, message: message, type: .error)
            let action = SMAlertAction(title: "OK", style: .gray, handler: completion)
            alert?.addAction(action: action)
        case .success(let title, let message):
            alert = SMAlertController(title: title, message: message, type: .success)
            let action = SMAlertAction(title: "OK", style: .gray, handler: completion)
            alert?.addAction(action: action)
        }
        return alert
    }
    
    class func hide(completion: (() -> Void)? = nil) {
        guard let top = UIApplication.shared.keyWindow, let alert = SMAlertController.alertForView(top) else {
            completion?()
            return
        }
        
        alert.hide(animated: true, completion: completion)
    }
    
}
