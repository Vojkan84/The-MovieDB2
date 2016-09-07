//
//  ProfileController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/4/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class ProfileController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
  
    @IBOutlet weak var LoginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileController.dismissKeyboard))
        view.addGestureRecognizer(tap)
      
    }
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
      TMDB.shaedInstance.signUp()
    }

    @IBAction func LoginButtonTapped(sender: UIButton) {
        
        if usernameTextField.text?.characters.count < 1 || passwordTextField.text?.characters.count < 1 {return}
        
        TMDB.shaedInstance.loginWithUsername(usernameTextField.text!, and: passwordTextField.text!)
       
    }
    

    
}
