//
//  ProfileController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 9/3/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarHidden = true
        
        
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
