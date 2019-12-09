//
//  RotatingLoaderWithRefresh.swift
//  Survey
//
//  Created by Piter Miller on 06.02.18.
//  Copyright © 2018 home. All rights reserved.
//

import UIKit

enum RotatingLoaderWithRefreshState {
    case showLoading
    case hideLoading
    case showReload
    case showEmptyListText(text: String)
}

class RotatingLoaderWithRefresh: UIView {

    @IBOutlet weak var loaderView: CircleRotatingLoader!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var loadingViewTitleLabel: UILabel!
    @IBOutlet weak var emptyListDescriptionLabel: UILabel!
    
    var refreshButtonPressedHandler: (() -> ())?
    
    func setState(state: RotatingLoaderWithRefreshState) {
        let all: [UIView] = [self, reloadButton, loaderView, loadingViewTitleLabel, emptyListDescriptionLabel]
        let toShow: [UIView]
        
        switch state {
        case .hideLoading:
            loaderView.stopAnimation()
            toShow = []
        
        case .showLoading:
            loadingViewTitleLabel.text = "Loading"
            toShow = [loaderView, loadingViewTitleLabel, self]
            loaderView.startAnimation()
        
        case .showReload:
            loadingViewTitleLabel.text = "Reload"
            toShow = [reloadButton, self]
            loaderView.stopAnimation()
        
        case .showEmptyListText(let text):
            loaderView.stopAnimation()
            emptyListDescriptionLabel.text = text
            configureEmptyListDescriptionLabel()
            toShow = [emptyListDescriptionLabel, self]
        }
        
        let toHide = all.exclude(toShow)
        toShow.forEach { $0.isHidden = false }
        toHide.forEach { $0.isHidden = true }
    }
    
    private func configureEmptyListDescriptionLabel() {
        //TODO: -
//        emptyListDescriptionLabel.setDefaultLineHeight()
    }
    
    @IBAction private func didTouchRetry() {
        refreshButtonPressedHandler?()
    }
    
    func setup() {
        setState(state: .hideLoading)
    }
    
}
