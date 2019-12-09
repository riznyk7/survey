//
//  SMAlertController.swift
//  home
//
//  Created by Piter Miller on 12/19/16.
//  Copyright © 2016 home. All rights reserved.
//

import UIKit
import AudioToolbox

final class SMAlertController: UIView {
    
    enum SMAlertControllerType {
        case progress
        case warning
        case error
        case success
        case `default`
        
        fileprivate func image() -> UIImage? {
            switch self {
            case .warning:
                return #imageLiteral(resourceName: "warning_image")
            case .error:
                return #imageLiteral(resourceName: "error_image")
            case .progress:
                return #imageLiteral(resourceName: "loader_big")
            case .success:
                return #imageLiteral(resourceName: "success_image")
            default:
                return nil
            }
        }
    }
    
    private(set) var actions: [SMAlertAction] = []
    private var alertContainerView: SMAlertView!
    private(set) var alertView: UIView!
    private(set) var textFields: [UITextField]?
    
    var isAlertFreeToCancel = true
    
    var buttonsBackgroundColor: UIColor? = nil {
        didSet {
            alertContainerView.buttonsBackgroundView.backgroundColor = buttonsBackgroundColor
        }
    }
    
    var buttonsAxis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            alertContainerView.buttonsStack?.axis = buttonsAxis
        }
    }
    
    private var type: SMAlertControllerType!
    
    var title: NSAttributedString? {
        didSet { updateUI() }
    }
    
    var message: NSAttributedString? {
        didSet { updateUI() }
    }
    
    //MARK: - Init
    
    convenience init(title: String?, message: String?, type: SMAlertControllerType, actions: [SMAlertAction] = []) {
        let attributedTitle = title.map(NSAttributedString.init)
        let attributedMessage = message.map(NSAttributedString.init)
        self.init(title: attributedTitle, message: attributedMessage, type: type)
        
        actions.forEach(addAction)
    }
    
    convenience init(title: NSAttributedString?, message: NSAttributedString?, type: SMAlertControllerType) {
        self.init()
        self.type = type
        self.title = title
        self.message = message
        
        backgroundColor = .clear
        
        registerForKeyboardNotifications()
        loadAlertView()
        addGestureRecognizer()
        updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadAlertView() {
        alertContainerView = SMAlertView.view()
        alertContainerView.buttonsStack.axis = buttonsAxis
        alertContainerView.buttonsBackgroundView.backgroundColor = buttonsBackgroundColor
        
        
        alertView = alertContainerView.alertView
        addSubview(alertContainerView)
        
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alertContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            alertContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            alertContainerView.topAnchor.constraint(equalTo: topAnchor),
            alertContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        alertContainerView.addGestureRecognizer(tap)
    }
    
    private func updateUI() {
        updateContent()
        updateElementsVisability()
    }
    
    private func updateContent() {
        alertContainerView.titleLabel.attributedText = title
        alertContainerView.textLabel.attributedText = message
        alertContainerView.topImageView.image = type.image()
    }
    
    private func updateElementsVisability() {
        updateActivityIndicatorVisability()
        updateTextAndImageVisability()
    }
    
    private func updateActivityIndicatorVisability() {
        if type == .progress {
            showActivityIndicator()
        } else {
            showAlertView()
        }
    }
    
    private func showActivityIndicator() {
        alertContainerView.alertView.isHidden = true
        alertContainerView.activityIndicator.isHidden = false
        alertContainerView.activityIndicator.startAnimation()
        isAlertFreeToCancel = false
    }
    
    private func showAlertView() {
        alertContainerView.alertView.isHidden = false
        alertContainerView.activityIndicator.isHidden = true
    }
    
    private func updateTextAndImageVisability() {
        alertContainerView.titleLabel.isHidden = title == nil
        alertContainerView.textLabel.isHidden = message == nil
        alertContainerView.topImageView.isHidden = type.image() == nil
    }

    func addAction(action: SMAlertAction) {
        let button = action.button!
        
        button.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
        actions.append(action)
        alertContainerView.buttonsStack.addArrangedSubview(button)
    }

    func addTextField(config: ((UITextField) -> Void)?) {
        let textField = UITextField()
        config?(textField)
        
        if textFields == nil {
            textFields = [textField]
        }
        else {
            textFields?.append(textField)
        }
        
        alertContainerView.mainStackView.addArrangedSubview(textField)
    }
    
    
    //MARK: - Actions
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        guard let alert = alertView, let sender = sender else {
            return
        }
        
        let location = sender.location(in: alertView)
        let tappedOnAlert = alert.bounds.contains(location)
        
        if !tappedOnAlert && isAlertFreeToCancel {
            hide(animated: true)
        }
    }
    
    @objc private func buttonWasTapped(_ sender: UIButton) {
        guard let action = actions.first(where: { $0.button == sender }) else {
            hide(animated: true)
            return
        }
        
        if action.shouldDismissAlert {
            hide(animated: true) {
                action.handler?(action)
            }
        }
        else {
            action.handler?(action)
        }
    }

    
    //MARK: - Appearance
    
    class func alertForView(_ view: UIView) -> SMAlertController? {
        let subviewsEnum = view.subviews.reversed()
        for subview in subviewsEnum {
            if subview is SMAlertController {
                return subview as? SMAlertController
            }
        }
        return nil
    }
    
    func show() {
        if let keyWindow = UIApplication.shared.keyWindow {
            show(on: keyWindow)
        }
    }
    
    func show(on view: UIView) {
        alpha = 0.0
        
        if let prevAlert = SMAlertController.alertForView(view) {
            prevAlert.hide(animated: false)
        }
        
        view.addSubview(self)
        view.endEditing(false)
        fillSuperview()
        animateAppearance()
        
        playAlertSound()
    }
    
    private func fillSuperview() {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        let views = ["view": self]
        
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: views))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: views))
    }
    
    private func animateAppearance() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    func hide(animated: Bool, completion: (() -> Void)? = nil) {
        if !animated {
            isHidden = true
            completion?()
            removeFromSuperview()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { _ in
            completion?()
            self.removeFromSuperview()
        }
    }
    
    //MARK: -
    //MARK: Sound
    
    private func playAlertSound() {
        if type == .error {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    //MARK: -
    //MARK: Keyboard Notifications
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardNotification(_ note: Notification) {
        let keyboardFrame = note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let convertedKeyboardFrame = self.convert(keyboardFrame, to: self.window)
        
        let transform: CGAffineTransform
        
        if note.name == UIResponder.keyboardWillHideNotification {
            transform = .identity
        }
        else {
            var yOffset = alertView.frame.intersection(convertedKeyboardFrame).height
            
            if yOffset > 0 {
                yOffset += 20
                transform = CGAffineTransform(translationX: 0, y: -yOffset)
            } else {
                transform = alertView.transform
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.transform = transform
        }
    }
}
