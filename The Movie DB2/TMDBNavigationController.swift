//
//  TMDBNavigationController.swift
//  The Movie DB2
//
//  Created by Vojkan Spasic on 8/20/16.
//  Copyright © 2016 Vojkan Spasic. All rights reserved.
//

import UIKit


class TMDBNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 16)!]
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // TO DO - kada pokusam da promenim velicinu title fonta ako sam to uradio nakon sto sam setovao boju title-a velicina fonta se ne menja

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
