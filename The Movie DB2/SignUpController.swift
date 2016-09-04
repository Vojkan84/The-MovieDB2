//
//  SignUpController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/4/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
   
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.themoviedb.org/account/signup")!))
    }
    

}
