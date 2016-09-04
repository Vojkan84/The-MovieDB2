//
//  ProfileController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/4/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
  
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
