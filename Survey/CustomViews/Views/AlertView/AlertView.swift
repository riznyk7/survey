//
//  AlertView.swift
//  Survey
//
//  Created by Piter Miller on 11/21/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

final class AlertView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    deinit {
        print("AlertView deinit...")
        unregisterFromNotifications()
    }
    
    private func setup() {
        registerForNotifications()
        clear()
        updateUI()
    }
    
    private func clear() {
        imageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func updateUI() {
        imageView.isHidden = imageView.image == nil
        titleLabel.isHidden = titleLabel.text == nil
        descriptionLabel.isHidden = descriptionLabel.text == nil
    }
    
    //MARK: - Notifications
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let label = object as? UILabel, keyPath == #keyPath(UILabel.text), label == titleLabel || label == descriptionLabel {
            let old = change?[.oldKey] as? String
            let new = change?[.newKey] as? String
            
            guard old != new else { return }
            
            label.isHidden = label.text == nil
        }
        else if let imageView = object as? UIImageView, keyPath == #keyPath(UIImageView.image), imageView == self.imageView {
            imageView.isHidden = imageView.image == nil
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func registerForNotifications() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        imageView.addObserver(self, forKeyPath: #keyPath(UIImageView.image), options: options, context: nil)
        titleLabel.addObserver(self, forKeyPath: #keyPath(UILabel.text), options: options, context: nil)
        descriptionLabel.addObserver(self, forKeyPath: #keyPath(UILabel.text), options: options, context: nil)
    }
    
    private func unregisterFromNotifications() {
        imageView.removeObserver(self, forKeyPath: #keyPath(UIImageView.image))
        titleLabel.removeObserver(self, forKeyPath: #keyPath(UILabel.text))
        descriptionLabel.removeObserver(self, forKeyPath: #keyPath(UILabel.text))
    }
}
