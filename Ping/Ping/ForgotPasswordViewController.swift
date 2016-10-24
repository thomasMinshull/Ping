//
//  ForgotPasswordViewController.swift
//  Ping
//
//  Created by thomas minshull on 2016-08-11.
//  Copyright © 2016 thomas minshull. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlComponents = URLComponents(string: "https://www.linkedin.com/uas/request-password-reset")
        
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        [self .performSegue(withIdentifier: "unwindToLoginViewController", sender: self)];
    }
    

}
