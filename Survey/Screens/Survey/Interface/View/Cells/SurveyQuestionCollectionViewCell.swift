//
//  SurveyQuestionCollectionViewCell.swift
//  Survey
//
//  Created by Piter Miller on 12/6/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

class SurveyQuestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var failedView: UIView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    private var onButtonPress: (() -> Void)?
    private var onTextChange: ((String?) -> Void)?

    
    @IBAction func didTouchButton(_ sender: Any) {
        onButtonPress?()
        textField.resignFirstResponder()
    }
    
    @IBAction func didTouchTextFieldDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func didChangeText(_ sender: UITextField) {
        onTextChange?(sender.text)
    }
    
    @IBAction func didTouchRetry(_ sender: Any) {
        onButtonPress?()
        textField.resignFirstResponder()
    }
    
    func configure(with item: DisplayItem) {
        actionButton.setTitle(item.buttonText, for: .normal)
        actionButton.isEnabled = item.isButtonEnabled
        questionLabel.text = item.question
        textField.text = item.answer

        onTextChange = item.onTextChange
        onButtonPress = item.onButtonSelect
        
        loadingIndicator.isHidden = !item.isLoading
        failedView.isHidden = !item.error
        textField.isEnabled = item.isTextFieldEnabled
    }

}

extension SurveyQuestionCollectionViewCell {
    
    struct DisplayItem {
        
        var isTextFieldEnabled: Bool
        var error: Bool
        var isLoading: Bool
        var question: String
        var answer: String?
        var isButtonEnabled: Bool
        var buttonText: String
        var onButtonSelect: (() -> Void)?
        var onTextChange: ((String?) -> Void)?
        
        init(item: SurveyQuestionItem,
             onButtonSelect: (() -> Void)?,
             onTextChange: ((String?) -> Void)?) {
            self.question = item.question.question
            self.answer = item.answer?.text
            
            self.buttonText = "Submit"
            self.onButtonSelect = onButtonSelect
            self.onTextChange = onTextChange
            self.isLoading = item.state == .loading
            self.isLoading = false
            self.error = false
            self.isButtonEnabled = false
            self.isTextFieldEnabled = false
            
            switch item.state {
            case .loading:
                self.isLoading = true
            case .failed:
                self.error = true
            case .submitted:
                self.buttonText = "Already submitted"
            case .default:
                self.isButtonEnabled = item.answer?.text.isEmpty == false
                self.isTextFieldEnabled = true
            }
        }
        
    }
}

