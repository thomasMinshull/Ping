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
        
        let urlComponents = NSURLComponents(string: "https://www.linkedin.com/uas/request-password-reset")
        
        if let url = urlComponents?.URL {
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
    }

    // ToDo add a way to dismiss this view controller 

}
