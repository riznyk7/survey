//
//  ViewController.swift
//  Survey
//
//  Created by Piter Miller on 16.03.18.
//  Copyright © 2018 home. All rights reserved.
//

import UIKit


protocol LoadableViewInterface: class {
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func showEmptyListPlaceholder(description: String)
}

protocol ReloadableViewInterface: LoadableViewInterface {
    func showReload()
}

class ViewControllerTop: ViewController {
    override func configureLoderViewContstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0)
        ])
    }
}

class ViewController: UIViewController {

    fileprivate var state: RotatingLoaderWithRefreshState = .hideLoading {
        didSet {
            loadingView.setState(state: state)
        }
    }
    
    fileprivate let loadingView: RotatingLoaderWithRefresh = UIView.fromNib()
    var onStartLoadingHandler: (() -> ())?
    var onStopLoadingHandler: (() -> ())?
    var onReloadHandler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.setState(state: state)
    }
    
    open func didTouchReloadButton() {
    }
    
    func configureLoderViewContstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureLoderView() {
        view.addSubview(loadingView)
        
        configureLoderViewContstraints()
        loadingView.setup()
        loadingView.refreshButtonPressedHandler = { [weak self] in self?.didTouchReloadButton() }
    }


}

extension ViewController: ReloadableViewInterface {
    func showReload() {
        state = .showReload
        onReloadHandler?()
    }
    
    func startLoadingAnimation() {
        state = .showLoading
        onStartLoadingHandler?()
    }
    
    func stopLoadingAnimation() {
        state = .hideLoading
        onStopLoadingHandler?()
    }
    
    func showEmptyListPlaceholder(description: String) {
        state = .showEmptyListText(text: description)
    }
}
