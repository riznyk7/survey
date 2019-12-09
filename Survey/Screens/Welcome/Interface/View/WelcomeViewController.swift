//
//  WelcomeViewController.swift
//  Survey
//
//  Created by Piter Miller on 12/5/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    var presenter: WelcomeModuleInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.setup()
    }
    
    @IBAction func didTouchNext(_ sender: Any) {
        presenter?.didTouchNextButton()
    }
    
    deinit {
        print("WelcomeViewController deinit...")
    }
}


//MARK: - WelcomeViewInterface

extension WelcomeViewController: WelcomeViewInterface {
    
}

